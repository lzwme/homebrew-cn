cask "font-playwrite-ng-modern" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritengmodernPlaywriteNGModern%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite NG Modern"
  homepage "https:fonts.google.comspecimenPlaywrite+NG+Modern"

  font "PlaywriteNGModern[wght].ttf"

  # No zap stanza required
end