cask "font-playwrite-gb-s" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflplaywritegbs"
  name "Playwrite GB S"
  homepage "https:github.comTypeTogetherPlaywrite"

  font "PlaywriteGBS-Italic[wght].ttf"
  font "PlaywriteGBS[wght].ttf"

  # No zap stanza required
end