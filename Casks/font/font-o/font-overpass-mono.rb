cask "font-overpass-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloverpassmonoOverpassMono%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Overpass Mono"
  homepage "https:fonts.google.comspecimenOverpass+Mono"

  font "OverpassMono[wght].ttf"

  # No zap stanza required
end