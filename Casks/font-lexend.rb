cask "font-lexend" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllexendLexend%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Lexend"
  desc "Expanded by font bureau with a range of 8 weights"
  homepage "https:fonts.google.comspecimenLexend"

  font "Lexend[wght].ttf"

  # No zap stanza required
end