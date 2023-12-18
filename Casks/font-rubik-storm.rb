cask "font-rubik-storm" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikstormRubikStorm-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Storm"
  homepage "https:fonts.google.comspecimenRubik+Storm"

  font "RubikStorm-Regular.ttf"

  # No zap stanza required
end