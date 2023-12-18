cask "font-advent-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofladventpro"
  name "Advent Pro"
  desc "Modern font designed for web and print"
  homepage "https:fonts.google.comspecimenAdvent+Pro"

  font "AdventPro-Italic[wdth,wght].ttf"
  font "AdventPro[wdth,wght].ttf"

  # No zap stanza required
end