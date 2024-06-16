cask "font-playwrite-au-nsw" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteaunswPlaywriteAUNSW%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite AU NSW"
  homepage "https:fonts.google.comspecimenPlaywrite+AU+NSW"

  font "PlaywriteAUNSW[wght].ttf"

  # No zap stanza required
end