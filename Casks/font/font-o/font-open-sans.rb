cask "font-open-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflopensans"
  name "Open Sans"
  homepage "https:fonts.google.comspecimenOpen+Sans"

  font "OpenSans-Italic[wdth,wght].ttf"
  font "OpenSans[wdth,wght].ttf"

  # No zap stanza required
end