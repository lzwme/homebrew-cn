cask "font-noto-sans-malayalam-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmalayalamuiNotoSansMalayalamUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Malayalam UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Malayalam+UI"

  font "NotoSansMalayalamUI[wdth,wght].ttf"

  # No zap stanza required
end