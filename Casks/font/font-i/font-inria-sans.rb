cask "font-inria-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflinriasans"
  name "Inria Sans"
  homepage "https:fonts.google.comspecimenInria+Sans"

  font "InriaSans-Bold.ttf"
  font "InriaSans-BoldItalic.ttf"
  font "InriaSans-Italic.ttf"
  font "InriaSans-Light.ttf"
  font "InriaSans-LightItalic.ttf"
  font "InriaSans-Regular.ttf"

  # No zap stanza required
end