cask "font-manrope" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmanropeManrope%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Manrope"
  homepage "https:fonts.google.comspecimenManrope"

  font "Manrope[wght].ttf"

  # No zap stanza required
end