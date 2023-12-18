cask "font-dm-serif-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldmserifdisplay"
  name "DM Serif Display"
  homepage "https:fonts.google.comspecimenDM+Serif+Display"

  font "DMSerifDisplay-Italic.ttf"
  font "DMSerifDisplay-Regular.ttf"

  # No zap stanza required
end