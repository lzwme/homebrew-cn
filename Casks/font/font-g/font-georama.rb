cask "font-georama" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgeorama"
  name "Georama"
  desc "Original typeface available in several widths and weights"
  homepage "https:fonts.google.comspecimenGeorama"

  font "Georama-Italic[wdth,wght].ttf"
  font "Georama[wdth,wght].ttf"

  # No zap stanza required
end