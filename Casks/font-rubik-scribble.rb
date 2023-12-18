cask "font-rubik-scribble" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikscribbleRubikScribble-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Scribble"
  homepage "https:fonts.google.comspecimenRubik+Scribble"

  font "RubikScribble-Regular.ttf"

  # No zap stanza required
end