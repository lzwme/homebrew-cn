cask "font-noto-sans-bengali-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansbengaliuiNotoSansBengaliUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Bengali UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Bengali+UI"

  font "NotoSansBengaliUI[wdth,wght].ttf"

  # No zap stanza required
end