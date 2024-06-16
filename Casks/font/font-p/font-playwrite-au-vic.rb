cask "font-playwrite-au-vic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteauvicPlaywriteAUVIC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite AU VIC"
  homepage "https:fonts.google.comspecimenPlaywrite+AU+VIC"

  font "PlaywriteAUVIC[wght].ttf"

  # No zap stanza required
end