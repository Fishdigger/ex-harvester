defmodule HttpClient do
  def get(url) when is_bitstring(url) do
    response = HTTPotion.get(url)
    if response.status_code == 200 do
      Poison.decode!(response.body)
    end
  end

  def post(url, object) when is_map(object) do
     json = Poison.encode!(object)
     HTTPotion.post!(url, [body: json])
  end
end
