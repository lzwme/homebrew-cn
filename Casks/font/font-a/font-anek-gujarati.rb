cask "font-anek-gujarati" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekgujaratiAnekGujarati%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Gujarati"
  homepage "https:fonts.google.comspecimenAnek+Gujarati"

  font "AnekGujarati[wdth,wght].ttf"

  # No zap stanza required
end