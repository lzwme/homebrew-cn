cask "font-cormorant-garamond" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcormorantgaramond"
  name "Cormorant Garamond"
  homepage "https:fonts.google.comspecimenCormorant+Garamond"

  font "CormorantGaramond-Italic[wght].ttf"
  font "CormorantGaramond[wght].ttf"

  # No zap stanza required
end