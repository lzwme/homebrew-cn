cask "font-charm" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcharm"
  name "Charm"
  homepage "https:fonts.google.comspecimenCharm"

  font "Charm-Bold.ttf"
  font "Charm-Regular.ttf"

  # No zap stanza required
end