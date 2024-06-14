cask "font-figtree" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfigtree"
  name "Figtree"
  homepage "https:fonts.google.comspecimenFigtree"

  font "Figtree-Italic[wght].ttf"
  font "Figtree[wght].ttf"

  # No zap stanza required
end