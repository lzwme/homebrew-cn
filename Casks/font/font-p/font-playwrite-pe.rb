cask "font-playwrite-pe" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritepePlaywritePE%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite PE"
  homepage "https:fonts.google.comspecimenPlaywrite+PE"

  font "PlaywritePE[wght].ttf"

  # No zap stanza required
end