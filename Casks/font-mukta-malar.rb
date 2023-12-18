cask "font-mukta-malar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmuktamalar"
  name "Mukta Malar"
  homepage "https:fonts.google.comspecimenMukta+Malar"

  font "MuktaMalar-Bold.ttf"
  font "MuktaMalar-ExtraBold.ttf"
  font "MuktaMalar-ExtraLight.ttf"
  font "MuktaMalar-Light.ttf"
  font "MuktaMalar-Medium.ttf"
  font "MuktaMalar-Regular.ttf"
  font "MuktaMalar-SemiBold.ttf"

  # No zap stanza required
end