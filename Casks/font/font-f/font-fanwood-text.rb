cask "font-fanwood-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfanwoodtext"
  name "Fanwood Text"
  homepage "https:fonts.google.comspecimenFanwood+Text"

  font "FanwoodText-Italic.ttf"
  font "FanwoodText-Regular.ttf"

  # No zap stanza required
end