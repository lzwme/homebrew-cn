cask "font-londrina-solid" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllondrinasolid"
  name "Londrina Solid"
  homepage "https:fonts.google.comspecimenLondrina+Solid"

  font "LondrinaSolid-Black.ttf"
  font "LondrinaSolid-Light.ttf"
  font "LondrinaSolid-Regular.ttf"
  font "LondrinaSolid-Thin.ttf"

  # No zap stanza required
end