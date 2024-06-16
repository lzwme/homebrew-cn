cask "font-playwrite-ie" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywriteiePlaywriteIE%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite IE"
  homepage "https:fonts.google.comspecimenPlaywrite+IE"

  font "PlaywriteIE[wght].ttf"

  # No zap stanza required
end