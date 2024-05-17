cask "font-rubik-moonrocks" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikmoonrocksRubikMoonrocks-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Moonrocks"
  homepage "https:fonts.google.comspecimenRubik+Moonrocks"

  font "RubikMoonrocks-Regular.ttf"

  # No zap stanza required
end