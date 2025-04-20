cask "font-ancizar-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflancizarserif"
  name "Ancizar Serif"
  homepage "https:github.comUNAL-OMDUNAL-Ancizar"

  font "AncizarSerif-Italic[wght].ttf"
  font "AncizarSerif[wght].ttf"

  # No zap stanza required
end