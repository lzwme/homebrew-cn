cask "font-athiti" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflathiti"
  name "Athiti"
  homepage "https:fonts.google.comspecimenAthiti"

  font "Athiti-Bold.ttf"
  font "Athiti-ExtraLight.ttf"
  font "Athiti-Light.ttf"
  font "Athiti-Medium.ttf"
  font "Athiti-Regular.ttf"
  font "Athiti-SemiBold.ttf"

  # No zap stanza required
end