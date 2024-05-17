cask "font-rubik-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikoneRubikOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik One"
  homepage "https:fonts.google.comspecimenRubik+One"

  font "RubikOne-Regular.ttf"

  # No zap stanza required
end