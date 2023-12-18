cask "font-averia-sans-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflaveriasanslibre"
  name "Averia Sans Libre"
  homepage "https:fonts.google.comspecimenAveria+Sans+Libre"

  font "AveriaSansLibre-Bold.ttf"
  font "AveriaSansLibre-BoldItalic.ttf"
  font "AveriaSansLibre-Italic.ttf"
  font "AveriaSansLibre-Light.ttf"
  font "AveriaSansLibre-LightItalic.ttf"
  font "AveriaSansLibre-Regular.ttf"

  # No zap stanza required
end