cask "font-lateef" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllateef"
  name "Lateef"
  homepage "https:fonts.google.comspecimenLateef"

  font "Lateef-Bold.ttf"
  font "Lateef-ExtraBold.ttf"
  font "Lateef-ExtraLight.ttf"
  font "Lateef-Light.ttf"
  font "Lateef-Medium.ttf"
  font "Lateef-Regular.ttf"
  font "Lateef-SemiBold.ttf"

  # No zap stanza required
end