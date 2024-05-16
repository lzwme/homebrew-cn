cask "font-dm-serif-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofldmseriftext"
  name "DM Serif Text"
  homepage "https:fonts.google.comspecimenDM+Serif+Text"

  font "DMSerifText-Italic.ttf"
  font "DMSerifText-Regular.ttf"

  # No zap stanza required
end