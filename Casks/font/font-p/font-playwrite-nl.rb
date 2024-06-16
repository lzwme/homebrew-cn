cask "font-playwrite-nl" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritenlPlaywriteNL%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite NL"
  homepage "https:fonts.google.comspecimenPlaywrite+NL"

  font "PlaywriteNL[wght].ttf"

  # No zap stanza required
end