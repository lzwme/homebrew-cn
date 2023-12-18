cask "font-anek-latin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflaneklatinAnekLatin%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Latin"
  homepage "https:fonts.google.comspecimenAnek+Latin"

  font "AnekLatin[wdth,wght].ttf"

  # No zap stanza required
end