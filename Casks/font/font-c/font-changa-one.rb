cask "font-changa-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflchangaone"
  name "Changa One"
  homepage "https:fonts.google.comspecimenChanga+One"

  font "ChangaOne-Italic.ttf"
  font "ChangaOne-Regular.ttf"

  # No zap stanza required
end