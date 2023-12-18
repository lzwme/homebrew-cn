cask "font-ysabeau-infant" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflysabeauinfant"
  name "Ysabeau Infant"
  homepage "https:fonts.google.comspecimenYsabeau+Infant"

  font "YsabeauInfant-Italic[wght].ttf"
  font "YsabeauInfant[wght].ttf"

  # No zap stanza required
end