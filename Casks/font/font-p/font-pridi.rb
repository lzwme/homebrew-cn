cask "font-pridi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpridi"
  name "Pridi"
  homepage "https:fonts.google.comspecimenPridi"

  font "Pridi-Bold.ttf"
  font "Pridi-ExtraLight.ttf"
  font "Pridi-Light.ttf"
  font "Pridi-Medium.ttf"
  font "Pridi-Regular.ttf"
  font "Pridi-SemiBold.ttf"

  # No zap stanza required
end