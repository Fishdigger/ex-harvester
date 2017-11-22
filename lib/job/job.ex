defmodule Job do

  def get(job_name) do
    url = build_route(job_name)
    case HttpClient.get(url) do
      {:ok, body} -> {:ok, Poison.decode!(body as: [%Models.Job{ExtraElements: [%Models.Job.ExtraElement{}]}])}
      {:error, _} -> :error
    end
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

  def start_next() do
    %Models.Job{
      Name: "DataCityHarvester-Custodian",
      LastJobStartDateTime: Timex.now
    }
  end

  def copy_sync_time(%Models.Job{} = previous) do
    %Models.Job.ExtraElement{Key: "nextWindowStart", Value: get_next_window_start(previous)}
  end

  def get_next_window_start(%Job{ExtraElements: [%Models.Job.ExtraElement{}] = eles} = job) do
    Enum.find(eles, job.LastJobStartDateTime, fn(e) ->
      e.Key == "nextWindowStart"
    end)
  end

  def timed_out(%Models.Job{ExtraElements: [%Models.Job.ExtraElement{}] = eles}) do
    key = Enum.find(eles, fn(e) ->
      e.Key == "timeout"
    end)
    ret = false
    if Timex.after?(Timex.now, key) do
       ret = true
    end
    ret
  end

  def calculate_timeout(num_records) do
    if num_records > 0 do
      Timex.now
      |> Timex.shift(seconds: num_records)
    else
      Timex.now
      |> Timex.shift(minutes: 15)
    end
  end

end
