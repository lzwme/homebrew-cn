cask "font-poiret-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpoiretonePoiretOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Poiret One"
  homepage "https:fonts.google.comspecimenPoiret+One"

  font "PoiretOne-Regular.ttf"

  # No zap stanza required
end