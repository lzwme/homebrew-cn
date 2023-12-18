cask "font-libre-barcode-39" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcode39LibreBarcode39-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode 39"
  homepage "https:fonts.google.comspecimenLibre+Barcode+39"

  font "LibreBarcode39-Regular.ttf"

  # No zap stanza required
end