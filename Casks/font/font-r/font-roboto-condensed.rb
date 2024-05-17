cask "font-roboto-condensed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrobotocondensed"
  name "Roboto Condensed"
  homepage "https:fonts.google.comspecimenRoboto+Condensed"

  font "RobotoCondensed-Italic[wght].ttf"
  font "RobotoCondensed[wght].ttf"

  # No zap stanza required
end