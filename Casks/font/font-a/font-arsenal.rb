cask "font-arsenal" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarsenal"
  name "Arsenal"
  homepage "https:fonts.google.comspecimenArsenal"

  font "Arsenal-Bold.ttf"
  font "Arsenal-BoldItalic.ttf"
  font "Arsenal-Italic.ttf"
  font "Arsenal-Regular.ttf"

  # No zap stanza required
end