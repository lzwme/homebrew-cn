cask "font-sixtyfour" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsixtyfourSixtyfour%5BBLED%2CSCAN%5D.ttf",
      verified: "github.comgooglefonts"
  name "Sixtyfour"
  homepage "https:fonts.google.comspecimenSixtyfour"

  font "Sixtyfour[BLED,SCAN].ttf"

  # No zap stanza required
end