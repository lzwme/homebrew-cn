cask "font-chau-philomene-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflchauphilomeneone"
  name "Chau Philomene One"
  homepage "https:fonts.google.comspecimenChau+Philomene+One"

  font "ChauPhilomeneOne-Italic.ttf"
  font "ChauPhilomeneOne-Regular.ttf"

  # No zap stanza required
end