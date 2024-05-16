cask "font-gamja-flower" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgamjaflowerGamjaFlower-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gamja Flower"
  homepage "https:fonts.google.comspecimenGamja+Flower"

  font "GamjaFlower-Regular.ttf"

  # No zap stanza required
end