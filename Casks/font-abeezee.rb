cask "font-abeezee" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflabeezee"
  name "ABeeZee"
  homepage "https:fonts.google.comspecimenABeeZee"

  font "ABeeZee-Italic.ttf"
  font "ABeeZee-Regular.ttf"

  # No zap stanza required
end