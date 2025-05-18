cask "font-playpen-sans-hebrew" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaypensanshebrewPlaypenSansHebrew%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playpen Sans Hebrew"
  homepage "https:fonts.google.comspecimenPlaypen+Sans+Hebrew"

  font "PlaypenSansHebrew[wght].ttf"

  # No zap stanza required
end