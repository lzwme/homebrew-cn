cask "font-playwrite-is" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteisPlaywriteIS%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IS"
  homepage "https:fonts.google.comspecimenPlaywrite+IS"

  font "PlaywriteIS[wght].ttf"

  # No zap stanza required
end