cask "font-hind-siliguri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhindsiliguri"
  name "Hind Siliguri"
  homepage "https:fonts.google.comspecimenHind+Siliguri"

  font "HindSiliguri-Bold.ttf"
  font "HindSiliguri-Light.ttf"
  font "HindSiliguri-Medium.ttf"
  font "HindSiliguri-Regular.ttf"
  font "HindSiliguri-SemiBold.ttf"

  # No zap stanza required
end