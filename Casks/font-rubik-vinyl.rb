cask "font-rubik-vinyl" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikvinylRubikVinyl-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Vinyl"
  homepage "https:fonts.google.comspecimenRubik+Vinyl"

  font "RubikVinyl-Regular.ttf"

  # No zap stanza required
end