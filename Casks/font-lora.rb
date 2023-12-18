cask "font-lora" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllora"
  name "Lora"
  homepage "https:fonts.google.comspecimenLora"

  font "Lora-Italic[wght].ttf"
  font "Lora[wght].ttf"

  # No zap stanza required
end