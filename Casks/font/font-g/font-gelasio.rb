cask "font-gelasio" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgelasio"
  name "Gelasio"
  homepage "https:fonts.google.comspecimenGelasio"

  font "Gelasio-Italic[wght].ttf"
  font "Gelasio[wght].ttf"

  # No zap stanza required
end