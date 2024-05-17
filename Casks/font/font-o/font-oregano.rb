cask "font-oregano" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloregano"
  name "Oregano"
  homepage "https:fonts.google.comspecimenOregano"

  font "Oregano-Italic.ttf"
  font "Oregano-Regular.ttf"

  # No zap stanza required
end