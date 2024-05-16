cask "font-karla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflkarla"
  name "Karla"
  homepage "https:fonts.google.comspecimenKarla"

  font "Karla-Italic[wght].ttf"
  font "Karla[wght].ttf"

  # No zap stanza required
end