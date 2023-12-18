cask "font-rubik-gemstones" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikgemstonesRubikGemstones-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Gemstones"
  homepage "https:fonts.google.comspecimenRubik+Gemstones"

  font "RubikGemstones-Regular.ttf"

  # No zap stanza required
end