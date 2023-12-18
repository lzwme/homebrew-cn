cask "font-exo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflexo"
  name "Exo"
  homepage "https:fonts.google.comspecimenExo"

  font "Exo-Italic[wght].ttf"
  font "Exo[wght].ttf"

  # No zap stanza required
end