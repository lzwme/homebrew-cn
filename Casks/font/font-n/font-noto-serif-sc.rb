cask "font-noto-serif-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifscNotoSerifSC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif SC"
  homepage "https:fonts.google.comspecimenNoto+Serif+SC"

  font "NotoSerifSC[wght].ttf"

  # No zap stanza required
end