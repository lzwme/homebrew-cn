cask "font-rum-raisin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrumraisinRumRaisin-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rum Raisin"
  homepage "https:fonts.google.comspecimenRum+Raisin"

  font "RumRaisin-Regular.ttf"

  # No zap stanza required
end