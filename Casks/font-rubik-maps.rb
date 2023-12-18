cask "font-rubik-maps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikmapsRubikMaps-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Maps"
  homepage "https:fonts.google.comspecimenRubik+Maps"

  font "RubikMaps-Regular.ttf"

  # No zap stanza required
end