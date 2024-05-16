cask "font-love-light" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllovelightLoveLight-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Love Light"
  desc "Adaptation of another font"
  homepage "https:fonts.google.comspecimenLove+Light"

  font "LoveLight-Regular.ttf"

  # No zap stanza required
end