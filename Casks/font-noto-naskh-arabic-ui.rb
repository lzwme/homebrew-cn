cask "font-noto-naskh-arabic-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotonaskharabicuiNotoNaskhArabicUI%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Naskh Arabic UI"
  homepage "https:fonts.google.comspecimenNoto+Naskh+Arabic+UI"

  font "NotoNaskhArabicUI[wght].ttf"

  # No zap stanza required
end