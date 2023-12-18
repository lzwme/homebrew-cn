cask "font-lexend-mega" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllexendmegaLexendMega%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Lexend Mega"
  homepage "https:fonts.google.comspecimenLexend+Mega"

  font "LexendMega[wght].ttf"

  # No zap stanza required
end