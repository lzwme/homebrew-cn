cask "font-literata" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflliterata"
  name "Literata"
  homepage "https:fonts.google.comspecimenLiterata"

  font "Literata-Italic[opsz,wght].ttf"
  font "Literata[opsz,wght].ttf"

  # No zap stanza required
end