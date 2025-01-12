cask "font-atkinson-hyperlegible-next" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflatkinsonhyperlegiblenext"
  name "Atkinson Hyperlegible Next"
  homepage "https:github.comgooglefontsatkinson-hyperlegible-next"

  font "AtkinsonHyperlegibleNext-Italic[wght].ttf"
  font "AtkinsonHyperlegibleNext[wght].ttf"

  # No zap stanza required
end