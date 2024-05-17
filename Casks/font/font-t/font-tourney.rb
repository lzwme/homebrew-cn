cask "font-tourney" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltourney"
  name "Tourney"
  desc "Completely solid"
  homepage "https:fonts.google.comspecimenTourney"

  font "Tourney-Italic[wdth,wght].ttf"
  font "Tourney[wdth,wght].ttf"

  # No zap stanza required
end