cask "font-playwrite-br" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritebrPlaywriteBR%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite BR"
  homepage "https:fonts.google.comspecimenPlaywrite+BR"

  font "PlaywriteBR[wght].ttf"

  # No zap stanza required
end