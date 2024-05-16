cask "font-encode-sans-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflencodesansscEncodeSansSC%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Encode Sans SC"
  homepage "https:fonts.google.comspecimenEncode+Sans+SC"

  font "EncodeSansSC[wdth,wght].ttf"

  # No zap stanza required
end