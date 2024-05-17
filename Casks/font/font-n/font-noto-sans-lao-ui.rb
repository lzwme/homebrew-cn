cask "font-noto-sans-lao-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanslaouiNotoSansLaoUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Lao UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Lao+UI"

  font "NotoSansLaoUI[wdth,wght].ttf"

  # No zap stanza required
end