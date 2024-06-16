cask "font-playwrite-au-sa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteausaPlaywriteAUSA%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite AU SA"
  homepage "https:fonts.google.comspecimenPlaywrite+AU+SA"

  font "PlaywriteAUSA[wght].ttf"

  # No zap stanza required
end