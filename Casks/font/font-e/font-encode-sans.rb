cask "font-encode-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflencodesansEncodeSans%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Encode Sans"
  homepage "https:fonts.google.comspecimenEncode+Sans"

  font "EncodeSans[wdth,wght].ttf"

  # No zap stanza required
end