cask "font-noto-sans-gurmukhi-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansgurmukhiuiNotoSansGurmukhiUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Gurmukhi UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Gurmukhi+UI"

  font "NotoSansGurmukhiUI[wdth,wght].ttf"

  # No zap stanza required
end