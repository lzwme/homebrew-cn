cask "font-neuton" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflneuton"
  name "Neuton"
  homepage "https:fonts.google.comspecimenNeuton"

  font "Neuton-Bold.ttf"
  font "Neuton-ExtraBold.ttf"
  font "Neuton-ExtraLight.ttf"
  font "Neuton-Italic.ttf"
  font "Neuton-Light.ttf"
  font "Neuton-Regular.ttf"

  # No zap stanza required
end