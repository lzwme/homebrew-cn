cask "font-fondamento" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfondamento"
  name "Fondamento"
  homepage "https:fonts.google.comspecimenFondamento"

  font "Fondamento-Italic.ttf"
  font "Fondamento-Regular.ttf"

  # No zap stanza required
end