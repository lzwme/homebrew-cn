cask "font-exo-2" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflexo2"
  name "Exo 2"
  homepage "https:fonts.google.comspecimenExo+2"

  font "Exo2-Italic[wght].ttf"
  font "Exo2[wght].ttf"

  # No zap stanza required
end