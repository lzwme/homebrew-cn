cask "font-sirin-stencil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsirinstencilSirinStencil-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sirin Stencil"
  homepage "https:fonts.google.comspecimenSirin+Stencil"

  font "SirinStencil-Regular.ttf"

  # No zap stanza required
end