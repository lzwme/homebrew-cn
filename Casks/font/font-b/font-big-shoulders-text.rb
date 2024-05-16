cask "font-big-shoulders-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshoulderstextBigShouldersText%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Text"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Text"

  font "BigShouldersText[wght].ttf"

  # No zap stanza required
end