cask "font-playpen-sans-arabic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaypensansarabicPlaypenSansArabic%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playpen Sans Arabic"
  homepage "https:fonts.google.comspecimenPlaypen+Sans+Arabic"

  font "PlaypenSansArabic[wght].ttf"

  # No zap stanza required
end