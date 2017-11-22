defmodule Output.Message do
  def build_message(%Models.MessageTitle{} = mt) do
    %{
      "Operation" => "INSERT",
      "PrimaryKeys" => %{
        "Key" => "TitleId",
        "Type" => "int"
      },
      "Data" => mt
    }
  end
end
