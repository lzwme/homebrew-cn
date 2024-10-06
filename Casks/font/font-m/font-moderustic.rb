cask "font-moderustic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmoderusticModerustic%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Moderustic"
  homepage "https:fonts.google.comspecimenModerustic"

  font "Moderustic[wght].ttf"

  # No zap stanza required
end