cask "font-noto-sans-khmer-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanskhmeruiNotoSansKhmerUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Khmer UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Khmer+UI"

  font "NotoSansKhmerUI[wdth,wght].ttf"

  # No zap stanza required
end