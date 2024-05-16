cask "font-libre-barcode-ean13-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllibrebarcodeean13textLibreBarcodeEAN13Text-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Libre Barcode EAN13 Text"
  desc "Led by lasse fister, a font and web developer based in nuremberg, germany"
  homepage "https:fonts.google.comspecimenLibre+Barcode+EAN13+Text"

  font "LibreBarcodeEAN13Text-Regular.ttf"

  # No zap stanza required
end