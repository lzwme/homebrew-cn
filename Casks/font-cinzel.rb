cask "font-cinzel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcinzelCinzel%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Cinzel"
  homepage "https:fonts.google.comspecimenCinzel"

  font "Cinzel[wght].ttf"

  # No zap stanza required
end