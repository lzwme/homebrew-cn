cask "font-rubik" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrubik"
  name "Rubik"
  homepage "https:fonts.google.comspecimenRubik"

  font "Rubik-Italic[wght].ttf"
  font "Rubik[wght].ttf"

  # No zap stanza required
end