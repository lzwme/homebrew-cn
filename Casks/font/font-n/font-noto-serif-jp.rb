cask "font-noto-serif-jp" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifjpNotoSerifJP%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif JP"
  homepage "https:fonts.google.comspecimenNoto+Serif+JP"

  font "NotoSerifJP[wght].ttf"

  # No zap stanza required
end