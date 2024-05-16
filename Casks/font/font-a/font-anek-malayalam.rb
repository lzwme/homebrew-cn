cask "font-anek-malayalam" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekmalayalamAnekMalayalam%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Malayalam"
  homepage "https:fonts.google.comspecimenAnek+Malayalam"

  font "AnekMalayalam[wdth,wght].ttf"

  # No zap stanza required
end