cask "font-chelsea-market" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchelseamarketChelseaMarket-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chelsea Market"
  homepage "https:fonts.google.comspecimenChelsea+Market"

  font "ChelseaMarket-Regular.ttf"

  # No zap stanza required
end