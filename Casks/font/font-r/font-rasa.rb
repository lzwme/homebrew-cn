cask "font-rasa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrasa"
  name "Rasa"
  homepage "https:fonts.google.comspecimenRasa"

  font "Rasa-Italic[wght].ttf"
  font "Rasa[wght].ttf"

  # No zap stanza required
end