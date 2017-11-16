defmodule Models.Job do
  @derive [Poison.Encoder, Poison.Decoder]

  defmodule ExtraElement do
    @derive [Poison.Encoder, Poison.Decoder]
    defstruct [
      :Key,
      :Value
    ]
  end

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

end
