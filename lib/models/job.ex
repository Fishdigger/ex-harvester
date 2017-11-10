defmodule Models.Job do
  @derive [Poison.Encoder, Poison.Decoder]
  defstruct [
    :Name,
    :Status,
    :LastJobStartDateTime,
    :LastJobEndDateTime,
    :RunTime,
    :InProcess,
    :ProcessedDatetimeUTC,
    :ExtraElements
  ]

  defmodule ExtraElement do
    @derive [Poison.Encoder, Poison.Decoder]
    defstruct [
      :Key,
      :Value
    ]
  end
end
