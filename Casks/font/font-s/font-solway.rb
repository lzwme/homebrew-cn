cask "font-solway" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsolway"
  name "Solway"
  homepage "https:fonts.google.comspecimenSolway"

  font "Solway-Bold.ttf"
  font "Solway-ExtraBold.ttf"
  font "Solway-Light.ttf"
  font "Solway-Medium.ttf"
  font "Solway-Regular.ttf"

  # No zap stanza required
end