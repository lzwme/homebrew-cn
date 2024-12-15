cask "font-playwrite-gb-s-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplaywritegbsguides"
  name "Playwrite GB S Guides"
  homepage "https:fonts.google.comspecimenPlaywrite+GB+S+Guides"

  font "PlaywriteGBSGuides-Italic.ttf"
  font "PlaywriteGBSGuides-Regular.ttf"

  # No zap stanza required
end