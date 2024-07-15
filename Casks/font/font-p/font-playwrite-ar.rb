cask "font-playwrite-ar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritearPlaywriteAR%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite AR"
  homepage "https:fonts.google.comspecimenPlaywrite+AR"

  font "PlaywriteAR[wght].ttf"

  # No zap stanza required
end