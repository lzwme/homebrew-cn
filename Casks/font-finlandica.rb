cask "font-finlandica" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfinlandica"
  name "Finlandica"
  homepage "https:fonts.google.comspecimenFinlandica"

  font "Finlandica-Italic[wght].ttf"
  font "Finlandica[wght].ttf"

  # No zap stanza required
end