cask "font-reem-kufi-fun" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflreemkufifunReemKufiFun%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Reem Kufi Fun"
  desc "Also the name of khaled's daughter"
  homepage "https:fonts.google.comspecimenReem+Kufi+Fun"

  font "ReemKufiFun[wght].ttf"

  # No zap stanza required
end