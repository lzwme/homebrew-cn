cask "font-libre-barcode-128-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcode128textLibreBarcode128Text-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode 128 Text"
  homepage "https:fonts.google.comspecimenLibre+Barcode+128+Text"

  font "LibreBarcode128Text-Regular.ttf"

  # No zap stanza required
end