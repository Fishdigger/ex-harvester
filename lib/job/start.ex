defmodule Job.Start do
  @in_progress "In Progress"
  @success "Success"
  @error "Error"

  def start do
    {:ok, previous_job} = Job.get(Config.job_name)
    if previous_job.InProcess == true and Job.timed_out(previous_job) == false do
      {:error, "Previous job in progress"}
    else
      run(previous_job)
    end
  end

  def run(%Models.Job{} = previous_job) do
    current_job = Job.start_next
    update_job(current_job, previous_job, "Requesting changes...", @in_progress, Job.calculate_timeout(0))
    case Queue.connect do
      {:ok, conn} -> conn
      {:error, _reason} -> update_job(current_job, previous_job, "Could not connect to queue", @error, Timex.zero)
    end
    case Queue.get_channel(conn) do
      {:ok, channel} -> channel
      {:error, _reason} -> update_job(current_job, previous_job, "Could not connect to queue", @error, Timex.zero)
    end
    target_window = %{
      StartDate: Job.get_next_window_start(previous_job),
      EndDate: current_job.LastJobStartDateTime
    }
    case HttpClient.get(Custodian.Route.build_since_route(target_window)) do
      {:ok, titles} -> titles
      :error -> update_job(current_job, previous_job, "Could not fetch from Custodian", @error, Timex.zero)
    end
    titles_models = Poison.decode!(titles as: [%Models.Title{credits: [%Models.Title.Credit{}]}])
    msg = "Publishing #{length(titles_models)} changes"
    update_job(current_job, previous_job, msg, @in_progress, Job.calculate_timeout(length(titles_models)))
    message_titles = Enum.map(titles_models, &Output.MessageTitle.build_message_title/1)
    message = Output.Message.build_messages(message_titles)
    case Queue.publish(channel, message) do
      {:ok, _} -> update_job(current_job, previous_job, "#{length(message_titles)} changes...", @success, Timex.zero)
      {:error, _} -> update_job(current_job, previous_job, "Failed to publish to queue", @error, Timex.zero)
    end
  end

  def update_job(%Models.Job{ExtraElements: [%Models.Job.ExtraElement{}]} = current, %Models.Job{} = previous, msg, status, timeout) do
    eles = [%Models.Job.ExtraElements{}]
    if timeout != Timex.zero do
      Enum.into(eles, %Models.Job.ExtraElement{
        Key: "timeout",
        Value: timeout
        })
    end
    Enum.into(eles, %Models.Job.ExtraElement{
      Key: "targetRange",
      Value: "#{Job.get_next_window_start(previous)} to #{Timex.now()}"
      })
    if msg != nil and msg != "" do
      Enum.into(eles, %Models.Job.ExtraElement{
        Key: "message",
        Value: msg
        })
    end
    if status != @success do
      Enum.into(eles, Job.copy_sync_time(previous))
    end
    job = %Models.Job{
      Status: status,
      InProcess: (status == @in_progress),
      LastJobEndDateTime: Timex.now(),
      RunTime: get_run_time(Timex.now(), current.LastJobStartDateTime),
      ExtraElements: eles
    }
    case Job.save(job) do
      {_ | status_code == 200} -> :ok
      {_ | status_code != 200} -> :error
    end
  end

  def get_run_time(start_time, end_time) do
     Timex.Duration.diff(end_time, start_time)
     |> Timex.Duration.to_time!
     |> Timex.Time.to_string
  end
end
