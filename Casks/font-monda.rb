cask "font-monda" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmondaMonda%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Monda"
  homepage "https:fonts.google.comspecimenMonda"

  font "Monda[wght].ttf"

  # No zap stanza required
end