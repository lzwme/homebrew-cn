cask "font-lexend-giga" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllexendgigaLexendGiga%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Lexend Giga"
  homepage "https:fonts.google.comspecimenLexend+Giga"

  font "LexendGiga[wght].ttf"

  # No zap stanza required
end