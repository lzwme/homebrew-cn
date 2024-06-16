cask "font-playwrite-tz" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritetzPlaywriteTZ%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite TZ"
  homepage "https:fonts.google.comspecimenPlaywrite+TZ"

  font "PlaywriteTZ[wght].ttf"

  # No zap stanza required
end