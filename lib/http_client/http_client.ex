defmodule HttpClient do
  def get(url) when is_bitstring(url) do
    case HTTPotion.get(url) do
       {:ok, response} -> {:ok, response.body}
       {:error, _} -> {:error, "Could not fetch from URL: #{url}"}
    end
  end

  def post(url, object) when is_map(object) do
     json = Poison.encode!(object)
     HTTPotion.post!(url, [body: json])
  end
end
