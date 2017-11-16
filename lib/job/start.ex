defmodule Job.Start do
  @in_progress = "In Progress"
  @success = "Success"
  @error = "Error"

  def start do
    previous_job = Job.last_run
    if previous_job.InProcess and Job.timed_out(previous_job) == false do
      result = {:error, "Job in progress."}
    end
    current_job = Job.start_next(previous_job)

  end

  def update_job(current = %Models.Job{}, previous = %Models.Job{}, msg, status, timeoutTime = %Timex.Time{}) when status == @in_progress do
    current.Status = status
    current.InProcess = true
    current.LastJobEndDateTime = Timex.now
    current.RunTime = get_run_time(current.LastJobStartDateTime, current.LastJobEndDateTime)
    Enum.into(%Models.Job.ExtraElement{Key: "targetRange", Value: "#{Job.get_next_window_start(previous)} to #{current.LastJobStartDateTime}"}, current.ExtraElements)
    #Kenneth's black magic needs to be explained.
  end

  def get_run_time(start_time, end_time) do
     Timex.Duration.diff(end_time, start_time)
     |> Timex.Duration.to_time!
     |> Timex.Time.to_string
  end
end
