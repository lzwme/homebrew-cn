cask "font-slackside-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflslacksideoneSlacksideOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Slackside One"
  homepage "https:fonts.google.comspecimenSlackside+One"

  font "SlacksideOne-Regular.ttf"

  # No zap stanza required
end