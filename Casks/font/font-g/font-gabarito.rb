cask "font-gabarito" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgabaritoGabarito%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Gabarito"
  desc "Geometric sans typeface with 6 weights ranging from regular to black"
  homepage "https:fonts.google.comspecimenGabarito"

  font "Gabarito[wght].ttf"

  # No zap stanza required
end