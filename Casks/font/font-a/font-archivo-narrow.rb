cask "font-archivo-narrow" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarchivonarrow"
  name "Archivo Narrow"
  homepage "https:fonts.google.comspecimenArchivo+Narrow"

  font "ArchivoNarrow-Italic[wght].ttf"
  font "ArchivoNarrow[wght].ttf"

  # No zap stanza required
end