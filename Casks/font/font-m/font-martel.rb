cask "font-martel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmartel"
  name "Martel"
  homepage "https:fonts.google.comspecimenMartel"

  font "Martel-Bold.ttf"
  font "Martel-DemiBold.ttf"
  font "Martel-ExtraBold.ttf"
  font "Martel-Heavy.ttf"
  font "Martel-Light.ttf"
  font "Martel-Regular.ttf"
  font "Martel-UltraLight.ttf"

  # No zap stanza required
end