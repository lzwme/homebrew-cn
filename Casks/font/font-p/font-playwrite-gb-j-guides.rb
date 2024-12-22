cask "font-playwrite-gb-j-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplaywritegbjguides"
  name "Playwrite GB J Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+GB+J+Guides"

  font "PlaywriteGBJGuides-Italic.ttf"
  font "PlaywriteGBJGuides-Regular.ttf"

  # No zap stanza required
end