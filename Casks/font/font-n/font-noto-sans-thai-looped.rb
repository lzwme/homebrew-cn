cask "font-noto-sans-thai-looped" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansthailoopedNotoSansThaiLooped%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Thai Looped"
  homepage "https:fonts.google.comspecimenNoto+Sans+Thai+Looped"

  font "NotoSansThaiLooped[wdth,wght].ttf"

  # No zap stanza required
end