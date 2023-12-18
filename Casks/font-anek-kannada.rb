cask "font-anek-kannada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekkannadaAnekKannada%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Kannada"
  homepage "https:fonts.google.comspecimenAnek+Kannada"

  font "AnekKannada[wdth,wght].ttf"

  # No zap stanza required
end