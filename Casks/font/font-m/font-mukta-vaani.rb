cask "font-mukta-vaani" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmuktavaani"
  name "Mukta Vaani"
  homepage "https:fonts.google.comspecimenMukta+Vaani"

  font "MuktaVaani-Bold.ttf"
  font "MuktaVaani-ExtraBold.ttf"
  font "MuktaVaani-ExtraLight.ttf"
  font "MuktaVaani-Light.ttf"
  font "MuktaVaani-Medium.ttf"
  font "MuktaVaani-Regular.ttf"
  font "MuktaVaani-SemiBold.ttf"

  # No zap stanza required
end