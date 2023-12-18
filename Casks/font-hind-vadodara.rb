cask "font-hind-vadodara" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhindvadodara"
  name "Hind Vadodara"
  homepage "https:fonts.google.comspecimenHind+Vadodara"

  font "HindVadodara-Bold.ttf"
  font "HindVadodara-Light.ttf"
  font "HindVadodara-Medium.ttf"
  font "HindVadodara-Regular.ttf"
  font "HindVadodara-SemiBold.ttf"

  # No zap stanza required
end