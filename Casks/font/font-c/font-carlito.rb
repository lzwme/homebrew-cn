cask "font-carlito" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcarlito"
  name "Carlito"
  homepage "https:fonts.google.comspecimenCarlito"

  font "Carlito-Bold.ttf"
  font "Carlito-BoldItalic.ttf"
  font "Carlito-Italic.ttf"
  font "Carlito-Regular.ttf"

  # No zap stanza required
end