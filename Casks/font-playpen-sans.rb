cask "font-playpen-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaypensansPlaypenSans%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playpen Sans"
  desc "Variable font with a weight range from thin to extrabold"
  homepage "https:fonts.google.comspecimenPlaypen+Sans"

  font "PlaypenSans[wght].ttf"

  # No zap stanza required
end