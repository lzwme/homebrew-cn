cask "font-texturina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltexturina"
  name "Texturina"
  homepage "https:fonts.google.comspecimenTexturina"

  font "Texturina-Italic[opsz,wght].ttf"
  font "Texturina[opsz,wght].ttf"

  # No zap stanza required
end