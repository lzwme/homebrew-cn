cask "font-averia-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflaverialibre"
  name "Averia Libre"
  homepage "https:fonts.google.comspecimenAveria+Libre"

  font "AveriaLibre-Bold.ttf"
  font "AveriaLibre-BoldItalic.ttf"
  font "AveriaLibre-Italic.ttf"
  font "AveriaLibre-Light.ttf"
  font "AveriaLibre-LightItalic.ttf"
  font "AveriaLibre-Regular.ttf"

  # No zap stanza required
end