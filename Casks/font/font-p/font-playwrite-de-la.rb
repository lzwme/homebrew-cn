cask "font-playwrite-de-la" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritedelaPlaywriteDELA%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite DE LA"
  homepage "https:fonts.google.comspecimenPlaywrite+DE+LA"

  font "PlaywriteDELA[wght].ttf"

  # No zap stanza required
end