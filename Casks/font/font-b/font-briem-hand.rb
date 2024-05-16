cask "font-briem-hand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbriemhandBriemHand%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Briem Hand"
  desc "Modern adaptation of sixteenth-century chancery cursive"
  homepage "https:fonts.google.comspecimenBriem+Hand"

  font "BriemHand[wght].ttf"

  # No zap stanza required
end