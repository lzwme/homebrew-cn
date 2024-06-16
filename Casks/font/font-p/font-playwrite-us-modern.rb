cask "font-playwrite-us-modern" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteusmodernPlaywriteUSModern%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite US Modern"
  homepage "https:fonts.google.comspecimenPlaywrite+US+Modern"

  font "PlaywriteUSModern[wght].ttf"

  # No zap stanza required
end