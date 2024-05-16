cask "font-changa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchangaChanga%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Changa"
  homepage "https:fonts.google.comspecimenChanga"

  font "Changa[wght].ttf"

  # No zap stanza required
end