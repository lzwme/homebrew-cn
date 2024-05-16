cask "font-jost" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofljost"
  name "Jost"
  homepage "https:fonts.google.comspecimenJost"

  font "Jost-Italic[wght].ttf"
  font "Jost[wght].ttf"

  # No zap stanza required
end