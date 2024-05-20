cask "font-playwrite-gb-j" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflplaywritegbj"
  name "Playwrite GB J"
  homepage "https:github.comTypeTogetherPlaywrite"

  font "PlaywriteGBJ-Italic[wght].ttf"
  font "PlaywriteGBJ[wght].ttf"

  # No zap stanza required
end