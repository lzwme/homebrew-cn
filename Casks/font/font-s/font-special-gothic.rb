cask "font-special-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflspecialgothicSpecialGothic%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Special Gothic"
  homepage "https:fonts.google.comspecimenSpecial+Gothic"

  font "SpecialGothic[wdth,wght].ttf"

  # No zap stanza required
end