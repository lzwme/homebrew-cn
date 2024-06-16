cask "font-playwrite-sk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteskPlaywriteSK%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite SK"
  homepage "https:fonts.google.comspecimenPlaywrite+SK"

  font "PlaywriteSK[wght].ttf"

  # No zap stanza required
end