cask "font-buenard" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbuenardBuenard%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Buenard"
  homepage "https:fonts.google.comspecimenBuenard"

  font "Buenard[wght].ttf"

  # No zap stanza required
end