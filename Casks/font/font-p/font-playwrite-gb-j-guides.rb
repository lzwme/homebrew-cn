cask "font-playwrite-gb-j-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflplaywritegbjguides"
  name "Playwrite GB J Guides"
  homepage "https:github.comTypeTogetherPlaywrite"

  font "PlaywriteGBJGuides-Italic.ttf"
  font "PlaywriteGBJGuides-Regular.ttf"

  # No zap stanza required
end