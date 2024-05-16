cask "font-archivo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarchivo"
  name "Archivo"
  homepage "https:fonts.google.comspecimenArchivo"

  font "Archivo-Italic[wdth,wght].ttf"
  font "Archivo[wdth,wght].ttf"

  # No zap stanza required
end