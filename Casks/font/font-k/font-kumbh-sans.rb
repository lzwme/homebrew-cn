cask "font-kumbh-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkumbhsansKumbhSans%5BYOPQ%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Kumbh Sans"
  homepage "https:fonts.google.comspecimenKumbh+Sans"

  font "KumbhSans[YOPQ,wght].ttf"

  # No zap stanza required
end