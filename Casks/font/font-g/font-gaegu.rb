cask "font-gaegu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgaegu"
  name "Gaegu"
  homepage "https:fonts.google.comspecimenGaegu"

  font "Gaegu-Bold.ttf"
  font "Gaegu-Light.ttf"
  font "Gaegu-Regular.ttf"

  # No zap stanza required
end