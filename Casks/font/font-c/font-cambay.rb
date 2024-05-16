cask "font-cambay" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcambay"
  name "Cambay"
  homepage "https:fonts.google.comspecimenCambay"

  font "Cambay-Bold.ttf"
  font "Cambay-BoldItalic.ttf"
  font "Cambay-Italic.ttf"
  font "Cambay-Regular.ttf"

  # No zap stanza required
end