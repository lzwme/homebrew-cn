cask "font-grandstander" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgrandstander"
  name "Grandstander"
  desc "Display variable font with a weight axis"
  homepage "https:fonts.google.comspecimenGrandstander"

  font "Grandstander-Italic[wght].ttf"
  font "Grandstander[wght].ttf"

  # No zap stanza required
end