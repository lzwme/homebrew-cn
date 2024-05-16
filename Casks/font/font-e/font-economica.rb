cask "font-economica" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofleconomica"
  name "Economica"
  homepage "https:fonts.google.comspecimenEconomica"

  font "Economica-Bold.ttf"
  font "Economica-BoldItalic.ttf"
  font "Economica-Italic.ttf"
  font "Economica-Regular.ttf"

  # No zap stanza required
end