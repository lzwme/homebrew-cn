cask "font-noto-sans-hanifi-rohingya" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanshanifirohingyaNotoSansHanifiRohingya%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Hanifi Rohingya"
  homepage "https:fonts.google.comspecimenNoto+Sans+Hanifi+Rohingya"

  font "NotoSansHanifiRohingya[wght].ttf"

  # No zap stanza required
end