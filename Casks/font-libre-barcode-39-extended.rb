cask "font-libre-barcode-39-extended" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcode39extendedLibreBarcode39Extended-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode 39 Extended"
  homepage "https:fonts.google.comspecimenLibre+Barcode+39+Extended"

  font "LibreBarcode39Extended-Regular.ttf"

  # No zap stanza required
end