cask "font-playwrite-za" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritezaPlaywriteZA%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite ZA"
  homepage "https:fonts.google.comspecimenPlaywrite+ZA"

  font "PlaywriteZA[wght].ttf"

  # No zap stanza required
end