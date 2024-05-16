cask "font-cairo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcairoCairo%5Bslnt%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Cairo"
  homepage "https:fonts.google.comspecimenCairo"

  font "Cairo[slnt,wght].ttf"

  # No zap stanza required
end