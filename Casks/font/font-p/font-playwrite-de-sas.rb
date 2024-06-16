cask "font-playwrite-de-sas" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritedesasPlaywriteDESAS%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite DE SAS"
  homepage "https:fonts.google.comspecimenPlaywrite+DE+SAS"

  font "PlaywriteDESAS[wght].ttf"

  # No zap stanza required
end