cask "font-playwrite-es" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteesPlaywriteES%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite ES"
  homepage "https:fonts.google.comspecimenPlaywrite+ES"

  font "PlaywriteES[wght].ttf"

  # No zap stanza required
end