cask "font-tajawal" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltajawal"
  name "Tajawal"
  homepage "https:fonts.google.comspecimenTajawal"

  font "Tajawal-Black.ttf"
  font "Tajawal-Bold.ttf"
  font "Tajawal-ExtraBold.ttf"
  font "Tajawal-ExtraLight.ttf"
  font "Tajawal-Light.ttf"
  font "Tajawal-Medium.ttf"
  font "Tajawal-Regular.ttf"

  # No zap stanza required
end