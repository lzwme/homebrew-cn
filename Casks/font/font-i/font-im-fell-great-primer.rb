cask "font-im-fell-great-primer" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflimfellgreatprimer"
  name "IM Fell Great Primer"
  homepage "https:fonts.google.comspecimenIM+Fell+Great+Primer"

  font "IMFeGPit28P.ttf"
  font "IMFeGPrm28P.ttf"

  # No zap stanza required
end