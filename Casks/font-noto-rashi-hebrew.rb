cask "font-noto-rashi-hebrew" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotorashihebrewNotoRashiHebrew%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Rashi Hebrew"
  homepage "https:fonts.google.comspecimenNoto+Rashi+Hebrew"

  font "NotoRashiHebrew[wght].ttf"

  # No zap stanza required
end