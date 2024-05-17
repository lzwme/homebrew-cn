cask "font-noto-sans-kannada-ui" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanskannadauiNotoSansKannadaUI%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Kannada UI"
  homepage "https:fonts.google.comspecimenNoto+Sans+Kannada+UI"

  font "NotoSansKannadaUI[wdth,wght].ttf"

  # No zap stanza required
end