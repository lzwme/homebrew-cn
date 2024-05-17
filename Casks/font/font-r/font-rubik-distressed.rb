cask "font-rubik-distressed" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikdistressedRubikDistressed-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Distressed"
  homepage "https:fonts.google.comspecimenRubik+Distressed"

  font "RubikDistressed-Regular.ttf"

  # No zap stanza required
end