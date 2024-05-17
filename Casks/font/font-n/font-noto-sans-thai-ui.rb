cask "font-noto-sans-thai-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansthaiuiNotoSansThaiUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Thai UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Thai+UI"

  font "NotoSansThaiUI[wdth,wght].ttf"

  # No zap stanza required
end