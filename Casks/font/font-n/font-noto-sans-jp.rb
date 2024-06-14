cask "font-noto-sans-jp" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansjpNotoSansJP%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans JP"
  homepage "https:fonts.google.comspecimenNoto+Sans+JP"

  font "NotoSansJP[wght].ttf"

  # No zap stanza required
end