cask "font-parastoo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflparastooParastoo%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Parastoo"
  homepage "https:fonts.google.comspecimenParastoo"

  font "Parastoo[wght].ttf"

  # No zap stanza required
end