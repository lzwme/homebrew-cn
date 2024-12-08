cask "font-playwrite-gb-s-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflplaywritegbsguides"
  name "Playwrite GB S Guides"
  homepage "https:github.comTypeTogetherPlaywrite"

  font "PlaywriteGBSGuides-Italic.ttf"
  font "PlaywriteGBSGuides-Regular.ttf"

  # No zap stanza required
end