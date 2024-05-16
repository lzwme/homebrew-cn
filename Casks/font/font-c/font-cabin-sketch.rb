cask "font-cabin-sketch" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcabinsketch"
  name "Cabin Sketch"
  homepage "https:fonts.google.comspecimenCabin+Sketch"

  font "CabinSketch-Bold.ttf"
  font "CabinSketch-Regular.ttf"

  # No zap stanza required
end