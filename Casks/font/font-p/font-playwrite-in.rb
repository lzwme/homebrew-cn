cask "font-playwrite-in" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteinPlaywriteIN%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IN"
  homepage "https:fonts.google.comspecimenPlaywrite+IN"

  font "PlaywriteIN[wght].ttf"

  # No zap stanza required
end