cask "font-pixelify-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpixelifysansPixelifySans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Pixelify Sans"
  homepage "https:fonts.google.comspecimenPixelify+Sans"

  font "PixelifySans[wght].ttf"

  # No zap stanza required
end