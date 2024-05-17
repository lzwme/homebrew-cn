cask "font-noto-sans-telugu-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansteluguuiNotoSansTeluguUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Telugu UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Telugu+UI"

  font "NotoSansTeluguUI[wdth,wght].ttf"

  # No zap stanza required
end