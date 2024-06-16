cask "font-playwrite-id" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteidPlaywriteID%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite ID"
  homepage "https:fonts.google.comspecimenPlaywrite+ID"

  font "PlaywriteID[wght].ttf"

  # No zap stanza required
end