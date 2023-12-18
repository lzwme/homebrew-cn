cask "font-palanquin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpalanquin"
  name "Palanquin"
  homepage "https:fonts.google.comspecimenPalanquin"

  font "Palanquin-Bold.ttf"
  font "Palanquin-ExtraLight.ttf"
  font "Palanquin-Light.ttf"
  font "Palanquin-Medium.ttf"
  font "Palanquin-Regular.ttf"
  font "Palanquin-SemiBold.ttf"
  font "Palanquin-Thin.ttf"

  # No zap stanza required
end