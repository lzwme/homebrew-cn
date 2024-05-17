cask "font-outfit" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofloutfitOutfit%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Outfit"
  homepage "https:fonts.google.comspecimenOutfit"

  font "Outfit[wght].ttf"

  # No zap stanza required
end