cask "font-playwrite-pt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteptPlaywritePT%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite PT"
  homepage "https:fonts.google.comspecimenPlaywrite+PT"

  font "PlaywritePT[wght].ttf"

  # No zap stanza required
end