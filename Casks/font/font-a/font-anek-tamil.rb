cask "font-anek-tamil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanektamilAnekTamil%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Tamil"
  homepage "https:fonts.google.comspecimenAnek+Tamil"

  font "AnekTamil[wdth,wght].ttf"

  # No zap stanza required
end