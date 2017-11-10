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

  def build_other_names(title = %Models.Title{}) do
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
      Enum.into(%OtherName{Type: "AKA", Name: akaName}, other_names)
    end)

    other_names
  end

  def build_participants(title = %Models.Title{credits: [%Models.Title.Credit{}]}) do
    participants = [%Participant{}]
    Enum.map(title.credits, fn(credit) ->
      if credit.role == "Director" and credit.name == title.director do
        Enum.into(%Participant{Name: credit.name, RoleType: credit.role, Bio: title.directorBio, ParticipantType: "Person"}, participants)
      else
        Enum.into(%Participant{Name: credit.name, RoleType: credit.role, ParticipantType: "Person"}, participants)
      end
    end)

    participants
  end
end
