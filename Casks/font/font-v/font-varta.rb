cask "font-varta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvartaVarta%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Varta"
  homepage "https:fonts.google.comspecimenVarta"

  font "Varta[wght].ttf"

  # No zap stanza required
end