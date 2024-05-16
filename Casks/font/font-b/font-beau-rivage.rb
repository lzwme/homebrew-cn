cask "font-beau-rivage" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbeaurivageBeauRivage-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Beau Rivage"
  desc "Classic calligraphic with strong contrast between thick and thin strokes"
  homepage "https:fonts.google.comspecimenBeau+Rivage"

  font "BeauRivage-Regular.ttf"

  # No zap stanza required
end