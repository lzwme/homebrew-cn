cask "font-playwrite-us-trad" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteustradPlaywriteUSTrad%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite US Trad"
  homepage "https:fonts.google.comspecimenPlaywrite+US+Trad"

  font "PlaywriteUSTrad[wght].ttf"

  # No zap stanza required
end