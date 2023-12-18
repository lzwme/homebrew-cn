cask "font-libre-bodoni" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllibrebodoni"
  name "Libre Bodoni"
  homepage "https:fonts.google.comspecimenLibre+Bodoni"

  font "LibreBodoni-Italic[wght].ttf"
  font "LibreBodoni[wght].ttf"

  # No zap stanza required
end