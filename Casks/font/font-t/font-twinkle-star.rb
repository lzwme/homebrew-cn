cask "font-twinkle-star" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltwinklestarTwinkleStar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Twinkle Star"
  homepage "https:fonts.google.comspecimenTwinkle+Star"

  font "TwinkleStar-Regular.ttf"

  # No zap stanza required
end