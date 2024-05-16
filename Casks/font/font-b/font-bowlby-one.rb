cask "font-bowlby-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbowlbyoneBowlbyOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bowlby One"
  homepage "https:fonts.google.comspecimenBowlby+One"

  font "BowlbyOne-Regular.ttf"

  # No zap stanza required
end