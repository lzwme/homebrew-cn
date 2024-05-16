cask "font-geostar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgeostarGeostar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Geostar"
  homepage "https:fonts.google.comspecimenGeostar"

  font "Geostar-Regular.ttf"

  # No zap stanza required
end