cask "font-noto-serif-georgian" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifgeorgianNotoSerifGeorgian%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Georgian"
  homepage "https:fonts.google.comspecimenNoto+Serif+Georgian"

  font "NotoSerifGeorgian[wdth,wght].ttf"

  # No zap stanza required
end