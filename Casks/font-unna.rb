cask "font-unna" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflunna"
  name "Unna"
  homepage "https:fonts.google.comspecimenUnna"

  font "Unna-Bold.ttf"
  font "Unna-BoldItalic.ttf"
  font "Unna-Italic.ttf"
  font "Unna-Regular.ttf"

  # No zap stanza required
end