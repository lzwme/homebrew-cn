cask "font-k2d" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflk2d"
  name "K2D"
  homepage "https:fonts.google.comspecimenK2D"

  font "K2D-Bold.ttf"
  font "K2D-BoldItalic.ttf"
  font "K2D-ExtraBold.ttf"
  font "K2D-ExtraBoldItalic.ttf"
  font "K2D-ExtraLight.ttf"
  font "K2D-ExtraLightItalic.ttf"
  font "K2D-Italic.ttf"
  font "K2D-Light.ttf"
  font "K2D-LightItalic.ttf"
  font "K2D-Medium.ttf"
  font "K2D-MediumItalic.ttf"
  font "K2D-Regular.ttf"
  font "K2D-SemiBold.ttf"
  font "K2D-SemiBoldItalic.ttf"
  font "K2D-Thin.ttf"
  font "K2D-ThinItalic.ttf"

  # No zap stanza required
end