cask "font-markazi-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmarkazitextMarkaziText%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Markazi Text"
  desc "Contemporary and highly readable typeface"
  homepage "https:fonts.google.comspecimenMarkazi+Text"

  font "MarkaziText[wght].ttf"

  # No zap stanza required
end