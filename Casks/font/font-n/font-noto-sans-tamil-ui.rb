cask "font-noto-sans-tamil-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanstamiluiNotoSansTamilUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Tamil UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Tamil+UI"

  font "NotoSansTamilUI[wdth,wght].ttf"

  # No zap stanza required
end