cask "font-caladea" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcaladea"
  name "Caladea"
  homepage "https:fonts.google.comspecimenCaladea"

  font "Caladea-Bold.ttf"
  font "Caladea-BoldItalic.ttf"
  font "Caladea-Italic.ttf"
  font "Caladea-Regular.ttf"

  # No zap stanza required
end