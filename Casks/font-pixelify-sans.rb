cask "font-pixelify-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpixelifysansPixelifySans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Pixelify Sans"
  desc "Achieved by using a grid of small, square pixels to create each letterform"
  homepage "https:fonts.google.comspecimenPixelify+Sans"

  font "PixelifySans[wght].ttf"

  # No zap stanza required
end