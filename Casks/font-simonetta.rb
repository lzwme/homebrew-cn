cask "font-simonetta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsimonetta"
  name "Simonetta"
  homepage "https:fonts.google.comspecimenSimonetta"

  font "Simonetta-Black.ttf"
  font "Simonetta-BlackItalic.ttf"
  font "Simonetta-Italic.ttf"
  font "Simonetta-Regular.ttf"

  # No zap stanza required
end