cask "font-the-nautigal" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflthenautigal"
  name "The Nautigal"
  homepage "https:fonts.google.comspecimenThe+Nautigal"

  font "TheNautigal-Bold.ttf"
  font "TheNautigal-Regular.ttf"

  # No zap stanza required
end