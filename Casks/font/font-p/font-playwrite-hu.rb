cask "font-playwrite-hu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritehuPlaywriteHU%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite HU"
  homepage "https:fonts.google.comspecimenPlaywrite+HU"

  font "PlaywriteHU[wght].ttf"

  # No zap stanza required
end