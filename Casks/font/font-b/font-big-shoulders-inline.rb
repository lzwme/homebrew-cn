cask "font-big-shoulders-inline" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersinlineBigShouldersInline%5Bopsz%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Inline"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Inline"

  font "BigShouldersInline[opsz,wght].ttf"

  # No zap stanza required
end