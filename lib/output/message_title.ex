defmodule Output.MessageTitle do
  def build_message_title(%Models.Title{} = title) do
    %Models.MessageTitle{
      TitleId: title.titleId,
      SourceId: title.sourceId,
      TitleName: title.title,
      OtherNames: build_other_names(title),
      TitleType: title.subType,
      ReleaseYear: title.releaseYear,
      Participants: build_participants(title),
      Language: [%Models.MessageTitle.Language{
        Name: title.language
      }],
      Storylines: build_storylines(title),
      Genres: Enum.map(title.genres, fn(g) -> %Models.MessageTitle.Genre{Name: g} end),
      Keywords: Enum.map(title.keywords, fn(k) -> %Models.MessageTitle.Keyword{Name: k} end),
      LengthInSeconds: title.duration,
      Awards: title.awards,
      MPAARating: title.mpaaRating,
      Version: %Models.MessageTitle.Version{
        AspectRatio: title.aspectRatio,
        AudioTrack: %Models.MessageTitle.AudioTrack{Description: title.audioTracksDescription}
      },
      Production: %Models.MessageTitle.Production {
        Copyright: title.copyRight,
        CountryOfOrigin: title.countryOfOrigin
      },
      Source: "FilmStruck",
      FilmStruck: %Models.MessageTitle.FilmStruck{
        TitleProperties: title.titleProperties
      }
    }
  end
  def build_other_names(%Models.Title{shortTitle: st, uiTitle: ui, akaNames: aka}) do
    other_names = [
      %Models.MessageTitle.OtherName{Type: "TitleBrief", Name: st},
      %Models.MessageTitle.OtherName{Type: "UITitle", Name: ui},
    ]
    Enum.map aka, fn(akaName) ->
      other_names ++ [%Models.MessageTitle.OtherName{Type: "AKA", Name: akaName}]
    end
    other_names
  end

  def build_participants(%Models.Title{credits: [%Models.Title.Credit{}] = credits, director: dir, directorBio: bio}) do
    Enum.map credits, fn(credit) ->
      if credit.role == "Director" and credit.name == dir do
        %Models.MessageTitle.Participant{Name: credit.name, RoleType: credit.role, Bio: bio, ParticpantType: "Person"}
      else
        %Models.MessageTitle.Participant{Name: credit.name, RoleType: credit.role, ParticipantType: "Person"}
      end
    end
  end

  def build_storylines(%Models.Title{shortStoryline: shorty, storyline: story}) do
    [
      %Models.MessageTitle.Storyline{Type: "Short", Description: shorty},
      %Models.MessageTitle.Storyline{Type: "Storyline", Description: story}
    ]
  end

end
