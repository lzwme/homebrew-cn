cask "font-montagu-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmontaguslabMontaguSlab%5Bopsz%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Montagu Slab"
  homepage "https:fonts.google.comspecimenMontagu+Slab"

  font "MontaguSlab[opsz,wght].ttf"

  # No zap stanza required
end