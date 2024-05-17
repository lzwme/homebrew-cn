cask "font-noto-sans-medefaidrin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmedefaidrinNotoSansMedefaidrin%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Medefaidrin"
  homepage "https:fonts.google.comspecimenNoto+Sans+Medefaidrin"

  font "NotoSansMedefaidrin[wght].ttf"

  # No zap stanza required
end