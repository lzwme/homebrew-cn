cask "font-anek-devanagari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekdevanagariAnekDevanagari%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Devanagari"
  homepage "https:fonts.google.comspecimenAnek+Devanagari"

  font "AnekDevanagari[wdth,wght].ttf"

  # No zap stanza required
end