cask "font-taviraj" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltaviraj"
  name "Taviraj"
  homepage "https:fonts.google.comspecimenTaviraj"

  font "Taviraj-Black.ttf"
  font "Taviraj-BlackItalic.ttf"
  font "Taviraj-Bold.ttf"
  font "Taviraj-BoldItalic.ttf"
  font "Taviraj-ExtraBold.ttf"
  font "Taviraj-ExtraBoldItalic.ttf"
  font "Taviraj-ExtraLight.ttf"
  font "Taviraj-ExtraLightItalic.ttf"
  font "Taviraj-Italic.ttf"
  font "Taviraj-Light.ttf"
  font "Taviraj-LightItalic.ttf"
  font "Taviraj-Medium.ttf"
  font "Taviraj-MediumItalic.ttf"
  font "Taviraj-Regular.ttf"
  font "Taviraj-SemiBold.ttf"
  font "Taviraj-SemiBoldItalic.ttf"
  font "Taviraj-Thin.ttf"
  font "Taviraj-ThinItalic.ttf"

  # No zap stanza required
end