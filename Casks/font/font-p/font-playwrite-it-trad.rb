cask "font-playwrite-it-trad" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteittradPlaywriteITTrad%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IT Trad"
  homepage "https:fonts.google.comspecimenPlaywrite+IT+Trad"

  font "PlaywriteITTrad[wght].ttf"

  # No zap stanza required
end