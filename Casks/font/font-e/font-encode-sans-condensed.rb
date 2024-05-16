cask "font-encode-sans-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflencodesanscondensed"
  name "Encode Sans Condensed"
  homepage "https:fonts.google.comspecimenEncode+Sans+Condensed"

  font "EncodeSansCondensed-Black.ttf"
  font "EncodeSansCondensed-Bold.ttf"
  font "EncodeSansCondensed-ExtraBold.ttf"
  font "EncodeSansCondensed-ExtraLight.ttf"
  font "EncodeSansCondensed-Light.ttf"
  font "EncodeSansCondensed-Medium.ttf"
  font "EncodeSansCondensed-Regular.ttf"
  font "EncodeSansCondensed-SemiBold.ttf"
  font "EncodeSansCondensed-Thin.ttf"

  # No zap stanza required
end