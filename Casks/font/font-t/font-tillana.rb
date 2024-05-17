cask "font-tillana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltillana"
  name "Tillana"
  homepage "https:fonts.google.comspecimenTillana"

  font "Tillana-Bold.ttf"
  font "Tillana-ExtraBold.ttf"
  font "Tillana-Medium.ttf"
  font "Tillana-Regular.ttf"
  font "Tillana-SemiBold.ttf"

  # No zap stanza required
end