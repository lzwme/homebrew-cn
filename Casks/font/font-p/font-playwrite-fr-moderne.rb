cask "font-playwrite-fr-moderne" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflplaywritefrmodernePlaywriteFRModerne%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Playwrite FR Moderne"
  homepage "https:fonts.google.comspecimenPlaywrite+FR+Moderne"

  font "PlaywriteFRModerne[wght].ttf"

  # No zap stanza required
end