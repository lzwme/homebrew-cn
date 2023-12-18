cask "font-libre-barcode-39-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcode39textLibreBarcode39Text-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode 39 Text"
  homepage "https:fonts.google.comspecimenLibre+Barcode+39+Text"

  font "LibreBarcode39Text-Regular.ttf"

  # No zap stanza required
end