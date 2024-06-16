cask "font-playwrite-de-grund" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritedegrundPlaywriteDEGrund%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite DE Grund"
  homepage "https:fonts.google.comspecimenPlaywrite+DE+Grund"

  font "PlaywriteDEGrund[wght].ttf"

  # No zap stanza required
end