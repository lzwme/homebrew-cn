cask "font-caveat" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcaveatCaveat%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Caveat"
  homepage "https:fonts.google.comspecimenCaveat"

  font "Caveat[wght].ttf"

  # No zap stanza required
end