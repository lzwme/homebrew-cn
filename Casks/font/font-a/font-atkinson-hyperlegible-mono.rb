cask "font-atkinson-hyperlegible-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflatkinsonhyperlegiblemono"
  name "Atkinson Hyperlegible Mono"
  homepage "https:fonts.google.comspecimenAtkinson+Hyperlegible+Mono"

  font "AtkinsonHyperlegibleMono-Italic[wght].ttf"
  font "AtkinsonHyperlegibleMono[wght].ttf"

  # No zap stanza required
end