cask "font-mukta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmukta"
  name "Mukta"
  homepage "https:fonts.google.comspecimenMukta"

  font "Mukta-Bold.ttf"
  font "Mukta-ExtraBold.ttf"
  font "Mukta-ExtraLight.ttf"
  font "Mukta-Light.ttf"
  font "Mukta-Medium.ttf"
  font "Mukta-Regular.ttf"
  font "Mukta-SemiBold.ttf"

  # No zap stanza required
end