cask "font-red-rose" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflredroseRedRose%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Red Rose"
  desc "Latin display typeface designed for posters"
  homepage "https:fonts.google.comspecimenRed+Rose"

  font "RedRose[wght].ttf"

  # No zap stanza required
end