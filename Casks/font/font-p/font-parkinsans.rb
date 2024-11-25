cask "font-parkinsans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflparkinsansParkinsans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Parkinsans"
  homepage "https:fonts.google.comspecimenParkinsans"

  font "Parkinsans[wght].ttf"

  # No zap stanza required
end