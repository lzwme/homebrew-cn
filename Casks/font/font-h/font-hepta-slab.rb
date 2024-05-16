cask "font-hepta-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflheptaslabHeptaSlab%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Hepta Slab"
  homepage "https:fonts.google.comspecimenHepta+Slab"

  font "HeptaSlab[wght].ttf"

  # No zap stanza required
end