cask "font-big-shoulders-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersdisplayBigShouldersDisplay%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Display"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Display"

  font "BigShouldersDisplay[wght].ttf"

  # No zap stanza required
end