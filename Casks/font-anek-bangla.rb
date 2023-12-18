cask "font-anek-bangla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanekbanglaAnekBangla%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anek Bangla"
  homepage "https:fonts.google.comspecimenAnek+Bangla"

  font "AnekBangla[wdth,wght].ttf"

  # No zap stanza required
end