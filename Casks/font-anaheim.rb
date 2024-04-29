cask "font-anaheim" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflanaheimAnaheim%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Anaheim"
  homepage "https:fonts.google.comspecimenAnaheim"

  font "Anaheim[wght].ttf"

  # No zap stanza required
end