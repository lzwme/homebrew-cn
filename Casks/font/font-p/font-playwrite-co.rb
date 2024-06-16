cask "font-playwrite-co" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritecoPlaywriteCO%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite CO"
  homepage "https:fonts.google.comspecimenPlaywrite+CO"

  font "PlaywriteCO[wght].ttf"

  # No zap stanza required
end