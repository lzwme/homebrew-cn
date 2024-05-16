cask "font-heebo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflheeboHeebo%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Heebo"
  homepage "https:fonts.google.comspecimenHeebo"

  font "Heebo[wght].ttf"

  # No zap stanza required
end