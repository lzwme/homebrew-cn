cask "font-comme" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcommeComme%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Comme"
  homepage "https:fonts.google.comspecimenComme"

  font "Comme[wght].ttf"

  # No zap stanza required
end