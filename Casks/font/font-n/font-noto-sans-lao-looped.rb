cask "font-noto-sans-lao-looped" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanslaoloopedNotoSansLaoLooped%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Lao Looped"
  desc "Looped variant of the southeast asian lao script"
  homepage "https:fonts.google.comspecimenNoto+Sans+Lao+Looped"

  font "NotoSansLaoLooped[wdth,wght].ttf"

  # No zap stanza required
end