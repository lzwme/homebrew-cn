cask "font-averia-serif-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflaveriaseriflibre"
  name "Averia Serif Libre"
  homepage "https:fonts.google.comspecimenAveria+Serif+Libre"

  font "AveriaSerifLibre-Bold.ttf"
  font "AveriaSerifLibre-BoldItalic.ttf"
  font "AveriaSerifLibre-Italic.ttf"
  font "AveriaSerifLibre-Light.ttf"
  font "AveriaSerifLibre-LightItalic.ttf"
  font "AveriaSerifLibre-Regular.ttf"

  # No zap stanza required
end