cask "font-baloo-2" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbaloo2Baloo2%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Baloo 2"
  homepage "https:fonts.google.comspecimenBaloo+2"

  font "Baloo2[wght].ttf"

  # No zap stanza required
end