cask "font-savate" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsavate"
  name "Savate"
  homepage "https:fonts.google.comspecimenSavate"

  font "Savate-Italic[wght].ttf"
  font "Savate[wght].ttf"

  # No zap stanza required
end