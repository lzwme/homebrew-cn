cask "font-grenze-gotisch" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgrenzegotischGrenzeGotisch%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Grenze Gotisch"
  homepage "https:fonts.google.comspecimenGrenze+Gotisch"

  font "GrenzeGotisch[wght].ttf"

  # No zap stanza required
end