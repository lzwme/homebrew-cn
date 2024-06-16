cask "font-playwrite-nz" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritenzPlaywriteNZ%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite NZ"
  homepage "https:fonts.google.comspecimenPlaywrite+NZ"

  font "PlaywriteNZ[wght].ttf"

  # No zap stanza required
end