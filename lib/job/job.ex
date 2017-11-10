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

end
