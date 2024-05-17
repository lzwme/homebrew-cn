cask "font-vollkorn-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflvollkornsc"
  name "Vollkorn SC"
  homepage "https:fonts.google.comspecimenVollkorn+SC"

  font "VollkornSC-Black.ttf"
  font "VollkornSC-Bold.ttf"
  font "VollkornSC-Regular.ttf"
  font "VollkornSC-SemiBold.ttf"

  # No zap stanza required
end