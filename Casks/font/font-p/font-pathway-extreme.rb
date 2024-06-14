cask "font-pathway-extreme" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpathwayextreme"
  name "Pathway Extreme"
  homepage "https:fonts.google.comspecimenPathway+Extreme"

  font "PathwayExtreme-Italic[opsz,wdth,wght].ttf"
  font "PathwayExtreme[opsz,wdth,wght].ttf"

  # No zap stanza required
end