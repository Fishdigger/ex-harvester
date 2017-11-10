defmodule ExHarvester do

  def start do
     url = Config.custodian_url <> "/2016-10-01/2016-10-04"
     body = HttpClient.get(url)
     titles = Poison.decode!(body, as: [%Models.Title{credits: [%Models.Title.Credit{}]}])
     IO.puts("#{Enum.count(titles)} titles found")
     Enum.each(titles, fn(t) ->
       IO.puts t.title
     end)
  end

end
