cask "font-istok-web" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflistokweb"
  name "Istok Web"
  homepage "https:fonts.google.comspecimenIstok+Web"

  font "IstokWeb-Bold.ttf"
  font "IstokWeb-BoldItalic.ttf"
  font "IstokWeb-Italic.ttf"
  font "IstokWeb-Regular.ttf"

  # No zap stanza required
end