cask "font-grandstander" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgrandstander"
  name "Grandstander"
  homepage "https:fonts.google.comspecimenGrandstander"

  font "Grandstander-Italic[wght].ttf"
  font "Grandstander[wght].ttf"

  # No zap stanza required
end