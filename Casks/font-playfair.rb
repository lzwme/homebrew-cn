cask "font-playfair" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplayfair"
  name "Playfair"
  homepage "https:fonts.google.comspecimenPlayfair"

  font "Playfair-Italic[opsz,wdth,wght].ttf"
  font "Playfair[opsz,wdth,wght].ttf"

  # No zap stanza required
end