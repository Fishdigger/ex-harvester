defmodule Job do

  def save(job) when is_map(job) do
    Config.job_name
    |> build_route
    |> HttpClient.post(job)
  end

end
