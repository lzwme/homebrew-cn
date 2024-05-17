cask "font-noto-sans-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansscNotoSansSC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans SC"
  desc "Sans-serif design for simplified chinese variant of the han ideograms"
  homepage "https:fonts.google.comspecimenNoto+Sans+SC"

  font "NotoSansSC[wght].ttf"

  # No zap stanza required
end