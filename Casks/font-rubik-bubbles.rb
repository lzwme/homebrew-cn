cask "font-rubik-bubbles" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikbubblesRubikBubbles-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Bubbles"
  homepage "https:fonts.google.comspecimenRubik+Bubbles"

  font "RubikBubbles-Regular.ttf"

  # No zap stanza required
end