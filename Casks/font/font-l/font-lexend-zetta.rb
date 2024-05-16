cask "font-lexend-zetta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllexendzettaLexendZetta%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Lexend Zetta"
  homepage "https:fonts.google.comspecimenLexend+Zetta"

  font "LexendZetta[wght].ttf"

  # No zap stanza required
end