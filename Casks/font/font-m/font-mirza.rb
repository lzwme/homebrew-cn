cask "font-mirza" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmirza"
  name "Mirza"
  homepage "https:fonts.google.comspecimenMirza"

  font "Mirza-Bold.ttf"
  font "Mirza-Medium.ttf"
  font "Mirza-Regular.ttf"
  font "Mirza-SemiBold.ttf"

  # No zap stanza required
end