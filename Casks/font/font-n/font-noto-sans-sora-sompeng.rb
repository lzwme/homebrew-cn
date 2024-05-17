cask "font-noto-sans-sora-sompeng" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssorasompengNotoSansSoraSompeng%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Sora Sompeng"
  homepage "https:fonts.google.comspecimenNoto+Sans+Sora+Sompeng"

  font "NotoSansSoraSompeng[wght].ttf"

  # No zap stanza required
end