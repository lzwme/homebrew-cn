cask "font-pixelify-sans" do
  version :latest
  sha256 :no_check

  url "https://github.com/google/fonts/raw/main/ofl/pixelifysans/PixelifySans%5Bwght%5D.ttf",
      verified: "github.com/google/fonts/"
  name "Pixelify Sans"
  desc "Achieved by using a grid of small, square pixels to create each letterform"
  homepage "https://fonts.google.com/specimen/Pixelify+Sans"

  font "PixelifySans[wght].ttf"

  # No zap stanza required
end