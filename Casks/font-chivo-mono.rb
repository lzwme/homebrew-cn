cask "font-chivo-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflchivomono"
  name "Chivo Mono"
  desc "Variable font ranging from thin to black with matching italics"
  homepage "https:fonts.google.comspecimenChivo+Mono"

  font "ChivoMono-Italic[wght].ttf"
  font "ChivoMono[wght].ttf"

  # No zap stanza required
end