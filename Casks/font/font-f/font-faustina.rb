cask "font-faustina" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfaustina"
  name "Faustina"
  homepage "https:fonts.google.comspecimenFaustina"

  font "Faustina-Italic[wght].ttf"
  font "Faustina[wght].ttf"

  # No zap stanza required
end