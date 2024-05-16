cask "font-biorhyme" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbiorhymeBioRhyme%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "BioRhyme"
  desc "Latin typeface family"
  homepage "https:fonts.google.comspecimenBioRhyme"

  font "BioRhyme[wdth,wght].ttf"

  # No zap stanza required
end