cask "font-noto-sans-arabic-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansarabicuiNotoSansArabicUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Arabic UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Arabic+UI"

  font "NotoSansArabicUI[wdth,wght].ttf"

  # No zap stanza required
end