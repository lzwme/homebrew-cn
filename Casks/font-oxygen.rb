cask "font-oxygen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofloxygen"
  name "Oxygen"
  homepage "https:fonts.google.comspecimenOxygen"

  font "Oxygen-Bold.ttf"
  font "Oxygen-Light.ttf"
  font "Oxygen-Regular.ttf"

  # No zap stanza required
end