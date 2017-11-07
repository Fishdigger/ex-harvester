defmodule Job do

  def get(job_name) do
    url = build_route(job_name)
    HttpClient.get(url)
  end

  def build_route(job_name) do
    "#{Config.datacity_url}/v1/job/#{job_name}?api_key=#{Config.datacity_api_key}"
  end

end
