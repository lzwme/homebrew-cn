cask "font-rubik-microbe" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikmicrobeRubikMicrobe-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Microbe"
  homepage "https:fonts.google.comspecimenRubik+Microbe"

  font "RubikMicrobe-Regular.ttf"

  # No zap stanza required
end