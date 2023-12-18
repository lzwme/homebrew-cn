cask "font-rubik-dirt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikdirtRubikDirt-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Dirt"
  homepage "https:fonts.google.comspecimenRubik+Dirt"

  font "RubikDirt-Regular.ttf"

  # No zap stanza required
end