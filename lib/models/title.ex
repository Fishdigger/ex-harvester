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
    :storyline,
    :genres,
    :keywords,
    :countryOfOrigin,
    :copyRight,
    :duration,
    :aspectRatio,
    :titleProperties,
    :sourceId,
    :mpaaRating,
    :audioTracksDescription
  ]

  defmodule Credit do
    defstruct [:role, :name]
  end
end
