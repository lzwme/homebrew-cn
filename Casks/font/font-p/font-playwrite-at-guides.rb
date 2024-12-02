cask "font-playwrite-at-guides" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflplaywriteatguides"
  name "Playwrite AT Guides"
  homepage "https:github.comTypeTogetherPlaywrite"

  font "PlaywriteATGuides-Italic.ttf"
  font "PlaywriteATGuides-Regular.ttf"

  # No zap stanza required
end