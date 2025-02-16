cask "font-atkinson-hyperlegible-next" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflatkinsonhyperlegiblenext"
  name "Atkinson Hyperlegible Next"
  homepage "https:fonts.google.comspecimenAtkinson+Hyperlegible+Next"

  font "AtkinsonHyperlegibleNext-Italic[wght].ttf"
  font "AtkinsonHyperlegibleNext[wght].ttf"

  # No zap stanza required
end