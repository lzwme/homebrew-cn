cask "font-hind-kochi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhindkochi"
  name "Hind Kochi"
  homepage "https:fonts.google.comspecimenHind"

  font "HindKochi-Bold.ttf"
  font "HindKochi-Light.ttf"
  font "HindKochi-Medium.ttf"
  font "HindKochi-Regular.ttf"
  font "HindKochi-SemiBold.ttf"

  # No zap stanza required
end