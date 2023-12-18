cask "font-rubik-lines" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubiklinesRubikLines-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Lines"
  homepage "https:fonts.google.comspecimenRubik+Lines"

  font "RubikLines-Regular.ttf"

  # No zap stanza required
end