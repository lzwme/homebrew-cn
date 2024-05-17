cask "font-wix-madefor-display" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwixmadefordisplayWixMadeforDisplay%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Wix Madefor Display"
  homepage "https:fonts.google.comspecimenWix+Madefor+Display"

  font "WixMadeforDisplay[wght].ttf"

  # No zap stanza required
end