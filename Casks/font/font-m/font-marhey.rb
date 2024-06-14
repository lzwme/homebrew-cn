cask "font-marhey" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarheyMarhey%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Marhey"
  homepage "https:fonts.google.comspecimenMarhey"

  font "Marhey[wght].ttf"

  # No zap stanza required
end