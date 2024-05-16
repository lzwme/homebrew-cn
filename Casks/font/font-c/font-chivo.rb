cask "font-chivo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflchivo"
  name "Chivo"
  homepage "https:fonts.google.comspecimenChivo"

  font "Chivo-Italic[wght].ttf"
  font "Chivo[wght].ttf"

  # No zap stanza required
end