cask "font-share" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflshare"
  name "Share"
  homepage "https:fonts.google.comspecimenShare"

  font "Share-Bold.ttf"
  font "Share-BoldItalic.ttf"
  font "Share-Italic.ttf"
  font "Share-Regular.ttf"

  # No zap stanza required
end