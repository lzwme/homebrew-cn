cask "font-noto-sans-bassa-vah" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansbassavahNotoSansBassaVah%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Bassa Vah"
  homepage "https:fonts.google.comspecimenNoto+Sans+Bassa+Vah"

  font "NotoSansBassaVah[wght].ttf"

  # No zap stanza required
end