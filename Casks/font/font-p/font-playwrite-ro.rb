cask "font-playwrite-ro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteroPlaywriteRO%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite RO"
  homepage "https:fonts.google.comspecimenPlaywrite+RO"

  font "PlaywriteRO[wght].ttf"

  # No zap stanza required
end