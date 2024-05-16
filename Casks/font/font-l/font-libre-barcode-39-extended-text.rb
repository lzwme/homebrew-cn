cask "font-libre-barcode-39-extended-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcode39extendedtextLibreBarcode39ExtendedText-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode 39 Extended Text"
  homepage "https:fonts.google.comspecimenLibre+Barcode+39+Extended+Text"

  font "LibreBarcode39ExtendedText-Regular.ttf"

  # No zap stanza required
end