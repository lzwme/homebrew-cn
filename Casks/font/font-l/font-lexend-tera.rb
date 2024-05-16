cask "font-lexend-tera" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllexendteraLexendTera%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Lexend Tera"
  homepage "https:fonts.google.comspecimenLexend+Tera"

  font "LexendTera[wght].ttf"

  # No zap stanza required
end