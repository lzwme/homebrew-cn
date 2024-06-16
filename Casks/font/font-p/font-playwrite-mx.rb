cask "font-playwrite-mx" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritemxPlaywriteMX%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite MX"
  homepage "https:fonts.google.comspecimenPlaywrite+MX"

  font "PlaywriteMX[wght].ttf"

  # No zap stanza required
end