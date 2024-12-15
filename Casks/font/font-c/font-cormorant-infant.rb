cask "font-cormorant-infant" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcormorantinfant"
  name "Cormorant Infant"
  homepage "https:fonts.google.comspecimenCormorant+Infant"

  font "CormorantInfant-Italic[wght].ttf"
  font "CormorantInfant[wght].ttf"

  # No zap stanza required
end