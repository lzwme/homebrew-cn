cask "font-epunda-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflepundaslab"
  name "Epunda Slab"
  homepage "https:github.comtypofacturepundaslab"

  font "EpundaSlab-Italic[wght].ttf"
  font "EpundaSlab[wght].ttf"

  # No zap stanza required
end