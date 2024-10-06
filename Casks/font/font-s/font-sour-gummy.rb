cask "font-sour-gummy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflsourgummy"
  name "Sour Gummy"
  homepage "https:github.comeifetxSour-Gummy-Fonts"

  font "SourGummy-Italic[wdth,wght].ttf"
  font "SourGummy[wdth,wght].ttf"

  # No zap stanza required
end