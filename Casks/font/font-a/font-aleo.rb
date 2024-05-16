cask "font-aleo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflaleo"
  name "Aleo"
  homepage "https:fonts.google.comspecimenAleo"

  font "Aleo-Italic[wght].ttf"
  font "Aleo[wght].ttf"

  # No zap stanza required
end