cask "font-noto-sans-sinhala-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssinhalauiNotoSansSinhalaUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Sinhala UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Sinhala+UI"

  font "NotoSansSinhalaUI[wdth,wght].ttf"

  # No zap stanza required
end