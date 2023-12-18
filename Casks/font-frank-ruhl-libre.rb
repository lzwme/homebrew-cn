cask "font-frank-ruhl-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflfrankruhllibreFrankRuhlLibre%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Frank Ruhl Libre"
  homepage "https:fonts.google.comspecimenFrank+Ruhl+Libre"

  font "FrankRuhlLibre[wght].ttf"

  # No zap stanza required
end