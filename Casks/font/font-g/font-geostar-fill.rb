cask "font-geostar-fill" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgeostarfillGeostarFill-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Geostar Fill"
  homepage "https:fonts.google.comspecimenGeostar+Fill"

  font "GeostarFill-Regular.ttf"

  # No zap stanza required
end