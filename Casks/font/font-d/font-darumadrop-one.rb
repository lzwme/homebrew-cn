cask "font-darumadrop-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldarumadroponeDarumadropOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Darumadrop One"
  homepage "https:fonts.google.comspecimenDarumadrop+One"

  font "DarumadropOne-Regular.ttf"

  # No zap stanza required
end