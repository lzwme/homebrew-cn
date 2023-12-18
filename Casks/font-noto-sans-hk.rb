cask "font-noto-sans-hk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanshkNotoSansHK%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans HK"
  desc "Sans-serif design using the traditional chinese variant of the han ideograms"
  homepage "https:fonts.google.comspecimenNoto+Sans+HK"

  font "NotoSansHK[wght].ttf"

  # No zap stanza required
end