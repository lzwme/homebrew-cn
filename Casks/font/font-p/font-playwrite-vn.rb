cask "font-playwrite-vn" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritevnPlaywriteVN%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite VN"
  homepage "https:fonts.google.comspecimenPlaywrite+VN"

  font "PlaywriteVN[wght].ttf"

  # No zap stanza required
end