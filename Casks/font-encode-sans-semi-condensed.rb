cask "font-encode-sans-semi-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflencodesanssemicondensed"
  name "Encode Sans Semi Condensed"
  homepage "https:fonts.google.comspecimenEncode+Sans+Semi+Condensed"

  font "EncodeSansSemiCondensed-Black.ttf"
  font "EncodeSansSemiCondensed-Bold.ttf"
  font "EncodeSansSemiCondensed-ExtraBold.ttf"
  font "EncodeSansSemiCondensed-ExtraLight.ttf"
  font "EncodeSansSemiCondensed-Light.ttf"
  font "EncodeSansSemiCondensed-Medium.ttf"
  font "EncodeSansSemiCondensed-Regular.ttf"
  font "EncodeSansSemiCondensed-SemiBold.ttf"
  font "EncodeSansSemiCondensed-Thin.ttf"

  # No zap stanza required
end