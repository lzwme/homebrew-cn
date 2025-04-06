cask "font-epunda-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflepundasans"
  name "Epunda Sans"
  homepage "https:github.comtypofacturepundasans"

  font "EpundaSans-Italic[wght].ttf"
  font "EpundaSans[wght].ttf"

  # No zap stanza required
end