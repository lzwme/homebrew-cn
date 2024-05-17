cask "font-noto-sans-meetei-mayek" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmeeteimayekNotoSansMeeteiMayek%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Meetei Mayek"
  homepage "https:fonts.google.comspecimenNoto+Sans+Meetei+Mayek"

  font "NotoSansMeeteiMayek[wght].ttf"

  # No zap stanza required
end