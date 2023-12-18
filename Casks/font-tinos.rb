cask "font-tinos" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apachetinos"
  name "Tinos"
  homepage "https:fonts.google.comspecimenTinos"

  font "Tinos-Bold.ttf"
  font "Tinos-BoldItalic.ttf"
  font "Tinos-Italic.ttf"
  font "Tinos-Regular.ttf"

  # No zap stanza required
end