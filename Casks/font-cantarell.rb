cask "font-cantarell" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcantarell"
  name "Cantarell"
  homepage "https:fonts.google.comspecimenCantarell"

  font "Cantarell-Bold.ttf"
  font "Cantarell-BoldItalic.ttf"
  font "Cantarell-Italic.ttf"
  font "Cantarell-Regular.ttf"

  # No zap stanza required
end