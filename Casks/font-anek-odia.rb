cask "font-anek-odia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekodiaAnekOdia%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Odia"
  homepage "https:fonts.google.comspecimenAnek+Odia"

  font "AnekOdia[wdth,wght].ttf"

  # No zap stanza required
end