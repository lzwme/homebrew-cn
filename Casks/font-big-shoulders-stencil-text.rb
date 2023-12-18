cask "font-big-shoulders-stencil-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersstenciltextBigShouldersStencilText%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Stencil Text"
  desc "Superfamily of condensed American Gothic typefaces"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Stencil+Text"

  font "BigShouldersStencilText[wght].ttf"

  # No zap stanza required
end