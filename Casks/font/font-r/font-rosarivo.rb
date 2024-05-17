cask "font-rosarivo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrosarivo"
  name "Rosarivo"
  homepage "https:fonts.google.comspecimenRosarivo"

  font "Rosarivo-Italic.ttf"
  font "Rosarivo-Regular.ttf"

  # No zap stanza required
end