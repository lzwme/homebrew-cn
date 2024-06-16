cask "font-playwrite-fr-trad" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritefrtradPlaywriteFRTrad%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite FR Trad"
  homepage "https:fonts.google.comspecimenPlaywrite+FR+Trad"

  font "PlaywriteFRTrad[wght].ttf"

  # No zap stanza required
end