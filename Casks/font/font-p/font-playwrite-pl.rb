cask "font-playwrite-pl" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteplPlaywritePL%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite PL"
  homepage "https:fonts.google.comspecimenPlaywrite+PL"

  font "PlaywritePL[wght].ttf"

  # No zap stanza required
end