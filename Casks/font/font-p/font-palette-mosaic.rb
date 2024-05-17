cask "font-palette-mosaic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpalettemosaicPaletteMosaic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Palette Mosaic"
  homepage "https:fonts.google.comspecimenPalette+Mosaic"

  font "PaletteMosaic-Regular.ttf"

  # No zap stanza required
end