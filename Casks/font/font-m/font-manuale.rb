cask "font-manuale" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmanuale"
  name "Manuale"
  homepage "https:fonts.google.comspecimenManuale"

  font "Manuale-Italic[wght].ttf"
  font "Manuale[wght].ttf"

  # No zap stanza required
end