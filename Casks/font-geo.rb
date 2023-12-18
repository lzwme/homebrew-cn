cask "font-geo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgeo"
  name "Geo"
  homepage "https:fonts.google.comspecimenGeo"

  font "Geo-Oblique.ttf"
  font "Geo-Regular.ttf"

  # No zap stanza required
end