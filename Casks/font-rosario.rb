cask "font-rosario" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrosario"
  name "Rosario"
  homepage "https:fonts.google.comspecimenRosario"

  font "Rosario-Italic[wght].ttf"
  font "Rosario[wght].ttf"

  # No zap stanza required
end