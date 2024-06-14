cask "font-glory" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflglory"
  name "Glory"
  homepage "https:fonts.google.comspecimenGlory"

  font "Glory-Italic[wght].ttf"
  font "Glory[wght].ttf"

  # No zap stanza required
end