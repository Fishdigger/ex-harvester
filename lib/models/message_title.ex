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

  defmodule FilmStruck do
    defstruct [:TitleProperties]
  end

end
