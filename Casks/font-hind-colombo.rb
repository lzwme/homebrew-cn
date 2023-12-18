cask "font-hind-colombo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhindcolombo"
  name "Hind Colombo"
  homepage "https:fonts.google.comspecimenHind"

  font "HindColombo-Bold.ttf"
  font "HindColombo-Light.ttf"
  font "HindColombo-Medium.ttf"
  font "HindColombo-Regular.ttf"
  font "HindColombo-SemiBold.ttf"

  # No zap stanza required
end