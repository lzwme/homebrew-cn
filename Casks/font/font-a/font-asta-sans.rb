cask "font-asta-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflastasansAstaSans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Asta Sans"
  homepage "https:fonts.google.comspecimenAsta+Sans"

  font "AstaSans[wght].ttf"

  # No zap stanza required
end