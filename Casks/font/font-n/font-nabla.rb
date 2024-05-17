cask "font-nabla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnablaNabla%5BEDPT%2CEHLT%5D.ttf",
      verified: "github.comgooglefonts"
  name "Nabla"
  desc "Color font inspired by isometric computer games, built using the colrv1 format"
  homepage "https:fonts.google.comspecimenNabla"

  font "Nabla[EDPT,EHLT].ttf"

  # No zap stanza required
end