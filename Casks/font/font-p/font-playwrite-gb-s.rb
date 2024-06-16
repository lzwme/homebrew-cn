cask "font-playwrite-gb-s" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplaywritegbs"
  name "Playwrite GB S"
  homepage "https:fonts.google.comspecimenPlaywrite+GB+S"

  font "PlaywriteGBS-Italic[wght].ttf"
  font "PlaywriteGBS[wght].ttf"

  # No zap stanza required
end