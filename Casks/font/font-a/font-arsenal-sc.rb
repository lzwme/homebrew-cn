cask "font-arsenal-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflarsenalsc"
  name "Arsenal SC"
  homepage "https:github.comalexeivaArsenal"

  font "ArsenalSC-Bold.ttf"
  font "ArsenalSC-BoldItalic.ttf"
  font "ArsenalSC-Italic.ttf"
  font "ArsenalSC-Regular.ttf"

  # No zap stanza required
end