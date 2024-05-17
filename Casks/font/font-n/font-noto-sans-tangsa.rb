cask "font-noto-sans-tangsa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanstangsaNotoSansTangsa%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Tangsa"
  desc "Design for the indic tangsa script"
  homepage "https:fonts.google.comspecimenNoto+Sans+Tangsa"

  font "NotoSansTangsa[wght].ttf"

  # No zap stanza required
end