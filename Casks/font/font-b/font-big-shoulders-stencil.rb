cask "font-big-shoulders-stencil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshouldersstencilBigShouldersStencil%5Bopsz%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Big Shoulders Stencil"
  homepage "https:fonts.google.comspecimenBig+Shoulders+Stencil"

  font "BigShouldersStencil[opsz,wght].ttf"

  # No zap stanza required
end