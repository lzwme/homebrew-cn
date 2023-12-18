cask "font-titillium-web" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltitilliumweb"
  name "Titillium Web"
  homepage "https:fonts.google.comspecimenTitillium+Web"

  font "TitilliumWeb-Black.ttf"
  font "TitilliumWeb-Bold.ttf"
  font "TitilliumWeb-BoldItalic.ttf"
  font "TitilliumWeb-ExtraLight.ttf"
  font "TitilliumWeb-ExtraLightItalic.ttf"
  font "TitilliumWeb-Italic.ttf"
  font "TitilliumWeb-Light.ttf"
  font "TitilliumWeb-LightItalic.ttf"
  font "TitilliumWeb-Regular.ttf"
  font "TitilliumWeb-SemiBold.ttf"
  font "TitilliumWeb-SemiBoldItalic.ttf"

  # No zap stanza required
end