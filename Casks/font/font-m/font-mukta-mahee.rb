cask "font-mukta-mahee" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmuktamahee"
  name "Mukta Mahee"
  homepage "https:fonts.google.comspecimenMukta+Mahee"

  font "MuktaMahee-Bold.ttf"
  font "MuktaMahee-ExtraBold.ttf"
  font "MuktaMahee-ExtraLight.ttf"
  font "MuktaMahee-Light.ttf"
  font "MuktaMahee-Medium.ttf"
  font "MuktaMahee-Regular.ttf"
  font "MuktaMahee-SemiBold.ttf"

  # No zap stanza required
end