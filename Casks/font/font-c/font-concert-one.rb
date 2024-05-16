cask "font-concert-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflconcertoneConcertOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Concert One"
  homepage "https:fonts.google.comspecimenConcert+One"

  font "ConcertOne-Regular.ttf"

  # No zap stanza required
end