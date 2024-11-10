cask "font-sour-gummy" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsourgummy"
  name "Sour Gummy"
  homepage "https:fonts.google.comspecimenSour+Gummy"

  font "SourGummy-Italic[wdth,wght].ttf"
  font "SourGummy[wdth,wght].ttf"

  # No zap stanza required
end