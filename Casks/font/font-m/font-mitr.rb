cask "font-mitr" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmitr"
  name "Mitr"
  homepage "https:fonts.google.comspecimenMitr"

  font "Mitr-Bold.ttf"
  font "Mitr-ExtraLight.ttf"
  font "Mitr-Light.ttf"
  font "Mitr-Medium.ttf"
  font "Mitr-Regular.ttf"
  font "Mitr-SemiBold.ttf"

  # No zap stanza required
end