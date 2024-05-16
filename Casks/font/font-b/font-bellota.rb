cask "font-bellota" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbellota"
  name "Bellota"
  homepage "https:fonts.google.comspecimenBellota"

  font "Bellota-Bold.ttf"
  font "Bellota-BoldItalic.ttf"
  font "Bellota-Italic.ttf"
  font "Bellota-Light.ttf"
  font "Bellota-LightItalic.ttf"
  font "Bellota-Regular.ttf"

  # No zap stanza required
end