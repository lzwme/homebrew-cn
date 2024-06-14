cask "font-water-brush" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwaterbrushWaterBrush-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Water Brush"
  homepage "https:fonts.google.comspecimenWater+Brush"

  font "WaterBrush-Regular.ttf"

  # No zap stanza required
end