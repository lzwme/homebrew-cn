cask "font-playwrite-hr" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritehrPlaywriteHR%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite HR"
  homepage "https:fonts.google.comspecimenPlaywrite+HR"

  font "PlaywriteHR[wght].ttf"

  # No zap stanza required
end