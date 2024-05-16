cask "font-great-vibes" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgreatvibesGreatVibes-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Great Vibes"
  homepage "https:fonts.google.comspecimenGreat+Vibes"

  font "GreatVibes-Regular.ttf"

  # No zap stanza required
end