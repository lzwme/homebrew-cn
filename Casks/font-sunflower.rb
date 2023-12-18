cask "font-sunflower" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsunflower"
  name "Sunflower"
  homepage "https:fonts.google.comspecimenSunflower"

  font "Sunflower-Bold.ttf"
  font "Sunflower-Light.ttf"
  font "Sunflower-Medium.ttf"

  # No zap stanza required
end