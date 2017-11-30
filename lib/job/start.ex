defmodule Job.Start do
  @in_progress "In Progress"
  @success "Success"
  @error "Error"

  def start do
    case Job.get(Config.job_name) do
      {:ok, %Models.Job{InProcess: true}} -> {:error, "Job in progress"}
      {:ok, %Models.Job{InProcess: false} = previous_job} -> run(previous_job)
      {:error, reason} -> {:error, "Could not fetch job, reason: #{reason}"}
    end
  end

  def run(%Models.Job{} = previous_job) do
    current_job = Job.start_next
    update_job(current_job, previous_job, "Getting previous job", @in_progress, Job.calculate_timeout(0))

    case get_queue() do
      {:ok, channel} -> 
        update_job(current_job, previous_job, "Requesting changes", @in_progress, Job.calculate_timeout(0))
        case get_models(previous_job, current_job) do
          {:ok, titles} ->
            messages = create_messages(titles)
            update_job(current_job, previous_job, "Publishing #{length(titles)} changes", @in_progress, Job.calculate_timeout(length(titles)))
            case Queue.publish(channel, messages) do
              {:ok, _} -> 
                update_job(current_job, previous_job, "#{length(titles)} changes", @success, Timex.zero)
                {:ok, @success}
              {:error, _} -> 
                update_job(current_job, previous_job, "Failed to publish to queue", @error, Timex.zero)
                {:error, @error}
            end
          {:error, reason} ->
            update_job(current_job, previous_job, reason, @error, Timex.zero)
            {:error, reason}
        end
      {:error, reason} -> 
        update_job(current_job, previous_job, reason, @error, Timex.zero)
        {:error, reason}
    end
  end

  defp get_queue do
    case Queue.connect do
      {:ok, connection} ->
        case Queue.get_channel(connection) do
          {:ok, channel} -> {:ok, channel}
          {:error, _} -> {:error, "Could not get queue channel"}
        end
      {:error, _} -> {:error, "Could not connect to queue"}
    end
  end

  defp get_models(previous, current) do
    target_window = %{
      StartDate: Job.get_next_window_start(previous),
      EndDate: current."LastJobStartDateTime"
    }
    case HttpClient.get(Custodian.Route.build_since_route(target_window)) do
      {:ok, data} -> 
        {:ok, Poison.decode(data, as: [%Models.Title{credits: [%Models.Title.Credit{}]}])}
      {:error, reason} -> {:error, reason}
    end
  end

  def create_messages([%Models.Title{}] = titles) do
    Enum.map(titles, &Output.MessageTitle.build_message_title/1)
    |> Enum.map(&Output.Message.build_message/1)
  end

  def update_job(%Models.Job{ExtraElements: [%Models.Job.ExtraElement{}]} = current, %Models.Job{} = previous, msg, status, timeout) do
    eles = [%Models.Job.ExtraElement{}]
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
      RunTime: get_run_time(Timex.now(), current."LastJobStartDateTime"),
      ExtraElements: eles
    }
    {_, _, status_code} = Job.save(job)
    case status_code do
      200 -> :ok
      _ -> :error
    end
  end

  def get_run_time(start_time, end_time) do
     Timex.Duration.diff(end_time, start_time)
     |> Timex.Duration.to_time!
  end
end
