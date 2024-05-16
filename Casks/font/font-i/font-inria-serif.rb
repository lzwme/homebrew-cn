cask "font-inria-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinriaserif"
  name "Inria Serif"
  homepage "https:fonts.google.comspecimenInria+Serif"

  font "InriaSerif-Bold.ttf"
  font "InriaSerif-BoldItalic.ttf"
  font "InriaSerif-Italic.ttf"
  font "InriaSerif-Light.ttf"
  font "InriaSerif-LightItalic.ttf"
  font "InriaSerif-Regular.ttf"

  # No zap stanza required
end