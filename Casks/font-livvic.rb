cask "font-livvic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllivvic"
  name "Livvic"
  homepage "https:fonts.google.comspecimenLivvic"

  font "Livvic-Black.ttf"
  font "Livvic-BlackItalic.ttf"
  font "Livvic-Bold.ttf"
  font "Livvic-BoldItalic.ttf"
  font "Livvic-ExtraLight.ttf"
  font "Livvic-ExtraLightItalic.ttf"
  font "Livvic-Italic.ttf"
  font "Livvic-Light.ttf"
  font "Livvic-LightItalic.ttf"
  font "Livvic-Medium.ttf"
  font "Livvic-MediumItalic.ttf"
  font "Livvic-Regular.ttf"
  font "Livvic-SemiBold.ttf"
  font "Livvic-SemiBoldItalic.ttf"
  font "Livvic-Thin.ttf"
  font "Livvic-ThinItalic.ttf"

  # No zap stanza required
end