cask "font-radio-canada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflradiocanada"
  name "Radio Canada"
  homepage "https:fonts.google.comspecimenRadio+Canada"

  font "RadioCanada-Italic[wdth,wght].ttf"
  font "RadioCanada[wdth,wght].ttf"

  # No zap stanza required
end