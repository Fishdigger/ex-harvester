defmodule Models.Message do
  def build_message(title = %Models.Title{}) do
    mt = to_message_title(title)
    %{
      "Operation" => "INSERT",
      "PrimaryKeys" => %{
        "Key" => "TitleId",
        "Type" => "int"
      },
      "Data" => mt
    }
  end

  def to_message_title(title = %Models.Title{}) do
    languages_list = String.split(title.language, ",", trim: true)

    %Models.MessageTitle{
      TitleId: title.titleId,
      SourceId: title.sourceId,
      TitleName: title.title,
      OtherNames: Models.MessageTitle.build_other_names(title),
      TitleType: %Models.MessageTitle.TitleType{Name: title.subType},
      ReleaseYear: title.releaseYear,
      Participants: Models.MessageTitle.build_participants(title),
      Language: Enum.map(languages_list, fn(l) -> %Models.MessageTitle.Language{Name: l} end),
      Storylines: [
        %Models.MessageTitle.Storyline{Type: "Short", Description: title.shortStoryline},
        %Models.MessageTitle.Storyline{Type: "Storyline", Description: title.storyline}
      ],
      Genres: Enum.map(title.genres, fn(g) -> %Models.MessageTitle.Genre{Name: g} end),
      Keywords: Enum.map(title.keywords, fn(k) -> %Models.MessageTitle.Keyword{Name: k} end),
      LengthInSeconds: title.duration,
      Awards: title.awards,
      MPAARating: title.mpaaRating,
      Version: %Models.MessageTitle.Version{
        AspectRatio: title.aspectRatio,
        AudioTrack: %Models.MessageTitle.AudioTrack{Description: title.audioTracksDescription}
      },
      Production: %Models.MessageTitle.Production{
        Copyright: title.copyRight,
        CountryOfOrigin: title.countryOfOrigin
      },
      Source: "FilmStruck",
      FilmStruck: %Models.MessageTitle.FilmStruck{
        TitleProperties: title.titleProperties
      }
    }
  end
end
