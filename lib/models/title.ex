defmodule Models.Title do
  @derive [Poison.Decoder]
  defstruct [
    :titleId,
    :title,
    :shortTitle,
    :uiTitle,
    :akaNames,
    :subType,
    :releaseYear,
    :credits,
    :director,
    :directorBio,
    :language,
    :shortStoryline,
    :genres,
    :keywords,
    :countryOfOrigin,
    :copyRight,
    :aspectRatio,
    :titleProperties
  ]
end

defmodule Models.MessageTitle do
  @derive [Poison.Encoder]
  defstruct [
    :TitleId,
    :SourceId,
    :TitleName,
    :OtherNames,
    :TitleType,
    :ReleaseYear,
    :Participants,
    :Language,
    :Storylines,
    :Genres,
    :Keywords,
    :LengthInSeconds,
    :Awards,
    :MPAARating,
    :Version,
    :Production,
    :Source,
    :FilmStruck
  ]

  defp build_other_names(title = %Title{}) do
    other_names = [%OtherName{}]
    if String.length(title.shortTitle) > 0 do
      shorty = %OtherName{Type: "TitleBrief", Name: title.shortTitle}
      Enum.into(shorty, other_names)
    end
    if String.length(title.uiTitle) > 0 do
      ui = %OtherName{Type: "UITitle", Name: title.uiTitle}
      Enum.into(ui, other_names)
    end

    Enum.each(title.akaNames, fn(akaName) ->
      Enum.into(%OtherName{Type: "AKA", Name: akaName})
    end)

    other_names
  end

  defmodule Participant do
    defstruct [
      :Name,
      :RoleType,
      :Bio,
      :ParticipantType
    ]
  end

  defmodule Language do
    defstruct [:Name]
  end

  defmodule TitleType do
    defstruct [:Name]
  end

  defmodule Storyline do
    defstruct [:Type, :Description]
  end

  defmodule Genre do
    defstruct [:Name]
  end

  defmodule Keyword do
    defstruct [:Name]
  end

  defmodule OtherName do
    defstruct [:Type, :Name]
  end

  defmodule Production do
    defstruct [:Copyright, :CountryOfOrigin]
  end

  defmodule Version do
    defstruct [:AspectRatio, :AudioTrack]
  end

  defmodule AudioTrack do
    defstruct [:Description]
  end
end
