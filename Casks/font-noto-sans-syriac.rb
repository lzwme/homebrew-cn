cask "font-noto-sans-syriac" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssyriacNotoSansSyriac%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Syriac"
  homepage "https:fonts.google.comspecimenNoto+Sans+Syriac"

  font "NotoSansSyriac[wght].ttf"

  # No zap stanza required
end