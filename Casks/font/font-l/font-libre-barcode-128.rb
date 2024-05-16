cask "font-libre-barcode-128" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcode128LibreBarcode128-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode 128"
  homepage "https:fonts.google.comspecimenLibre+Barcode+128"

  font "LibreBarcode128-Regular.ttf"

  # No zap stanza required
end