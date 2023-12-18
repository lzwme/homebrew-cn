cask "font-catamaran" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcatamaranCatamaran%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Catamaran"
  homepage "https:fonts.google.comspecimenCatamaran"

  font "Catamaran[wght].ttf"

  # No zap stanza required
end