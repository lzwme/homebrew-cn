cask "font-playwrite-at" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplaywriteat"
  name "Playwrite AT"
  homepage "https:fonts.google.comspecimenPlaywrite+AT"

  font "PlaywriteAT-Italic[wght].ttf"
  font "PlaywriteAT[wght].ttf"

  # No zap stanza required
end