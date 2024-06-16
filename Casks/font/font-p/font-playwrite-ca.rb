cask "font-playwrite-ca" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritecaPlaywriteCA%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CA"
  homepage "https:fonts.google.comspecimenPlaywrite+CA"

  font "PlaywriteCA[wght].ttf"

  # No zap stanza required
end