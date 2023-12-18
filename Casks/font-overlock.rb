cask "font-overlock" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloverlock"
  name "Overlock"
  homepage "https:fonts.google.comspecimenOverlock"

  font "Overlock-Black.ttf"
  font "Overlock-BlackItalic.ttf"
  font "Overlock-Bold.ttf"
  font "Overlock-BoldItalic.ttf"
  font "Overlock-Italic.ttf"
  font "Overlock-Regular.ttf"

  # No zap stanza required
end