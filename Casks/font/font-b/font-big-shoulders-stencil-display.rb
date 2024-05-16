cask "font-big-shoulders-stencil-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersstencildisplayBigShouldersStencilDisplay%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Stencil Display"
  desc "Superfamily of condensed American Gothic typefaces"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Stencil+Display"

  font "BigShouldersStencilDisplay[wght].ttf"

  # No zap stanza required
end