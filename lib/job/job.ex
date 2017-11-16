defmodule Job do

  def get(job_name) do
    build_route(job_name)
    |> HttpClient.get
    |> Poison.decode!(as: [%Models.Job{ExtraElements: [%Models.Job.ExtraElement{}]}])
  end

  def build_route(job_name) do
    "#{Config.datacity_url}/v1/job/#{job_name}?api_key=#{Config.datacity_api_key}"
  end

  def save(job) when is_map(job) do
    Config.job_name
    |> build_route
    |> HttpClient.post(job)
  end

  def last_run do
    get(Config.job_name)
  end


  def start_next(job = %Models.Job{}) do
    %Models.Job{
      Name: "DataCityHarvester-Custodian",
      LastJobStartDateTime: Timex.now
    }
  end

  def copy_sync_time(previous_job = %Models.Job{ExtraElements: [%Models.Job.ExtraElement{}]}, current_job = %Models.Job{}) do
    element = %Models.Job.ExtraElement{Key: "nextWindowStart", Value: get_next_window_start(previous_job)}
    Enum.into(element, curent_job.ExtraElements)
  end

  def get_next_window_start(job = %Job{ExtraElements: [%Models.Job.ExtraElement{}]}) do
    Enum.find(job.ExtraElements, job.LastJobStartDateTime, fn(e) ->
      e.Key == "nextWindowStart"
    end)
  end

  def timed_out(job = %Models.Job{ExtraElements: [%Models.Job.ExtraElement{}]}) do
    key = Enum.find(job.ExtraElements, fn(e) ->
      e.Key == "timeout"
    end)
    ret = false
    if Timex.after?(Timex.now, key) do
       ret = true
    end
    ret
  end

end
