cask "font-big-shoulders-inline-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersinlinedisplayBigShouldersInlineDisplay%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Inline Display"
  desc "Superfamily of condensed American Gothic typefaces"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Inline+Display"

  font "BigShouldersInlineDisplay[wght].ttf"

  # No zap stanza required
end