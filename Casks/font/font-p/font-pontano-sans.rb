cask "font-pontano-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpontanosansPontanoSans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Pontano Sans"
  homepage "https:fonts.google.comspecimenPontano+Sans"

  font "PontanoSans[wght].ttf"

  # No zap stanza required
end