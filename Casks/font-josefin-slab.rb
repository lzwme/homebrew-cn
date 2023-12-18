cask "font-josefin-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofljosefinslab"
  name "Josefin Slab"
  homepage "https:fonts.google.comspecimenJosefin+Slab"

  font "JosefinSlab-Italic[wght].ttf"
  font "JosefinSlab[wght].ttf"

  # No zap stanza required
end