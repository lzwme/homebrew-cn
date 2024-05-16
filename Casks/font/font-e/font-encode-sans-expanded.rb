cask "font-encode-sans-expanded" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflencodesansexpanded"
  name "Encode Sans Expanded"
  homepage "https:fonts.google.comspecimenEncode+Sans+Expanded"

  font "EncodeSansExpanded-Black.ttf"
  font "EncodeSansExpanded-Bold.ttf"
  font "EncodeSansExpanded-ExtraBold.ttf"
  font "EncodeSansExpanded-ExtraLight.ttf"
  font "EncodeSansExpanded-Light.ttf"
  font "EncodeSansExpanded-Medium.ttf"
  font "EncodeSansExpanded-Regular.ttf"
  font "EncodeSansExpanded-SemiBold.ttf"
  font "EncodeSansExpanded-Thin.ttf"

  # No zap stanza required
end