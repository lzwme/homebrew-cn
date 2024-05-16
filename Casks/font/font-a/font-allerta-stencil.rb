cask "font-allerta-stencil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflallertastencilAllertaStencil-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Allerta Stencil"
  homepage "https:fonts.google.comspecimenAllerta+Stencil"

  font "AllertaStencil-Regular.ttf"

  # No zap stanza required
end