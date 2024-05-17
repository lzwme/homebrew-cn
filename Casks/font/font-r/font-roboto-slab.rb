cask "font-roboto-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacherobotoslabRobotoSlab%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Roboto Slab"
  homepage "https:fonts.google.comspecimenRoboto+Slab"

  font "RobotoSlab[wght].ttf"

  # No zap stanza required
end