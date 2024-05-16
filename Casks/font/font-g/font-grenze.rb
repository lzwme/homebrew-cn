cask "font-grenze" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgrenze"
  name "Grenze"
  homepage "https:fonts.google.comspecimenGrenze"

  font "Grenze-Black.ttf"
  font "Grenze-BlackItalic.ttf"
  font "Grenze-Bold.ttf"
  font "Grenze-BoldItalic.ttf"
  font "Grenze-ExtraBold.ttf"
  font "Grenze-ExtraBoldItalic.ttf"
  font "Grenze-ExtraLight.ttf"
  font "Grenze-ExtraLightItalic.ttf"
  font "Grenze-Italic.ttf"
  font "Grenze-Light.ttf"
  font "Grenze-LightItalic.ttf"
  font "Grenze-Medium.ttf"
  font "Grenze-MediumItalic.ttf"
  font "Grenze-Regular.ttf"
  font "Grenze-SemiBold.ttf"
  font "Grenze-SemiBoldItalic.ttf"
  font "Grenze-Thin.ttf"
  font "Grenze-ThinItalic.ttf"

  # No zap stanza required
end