cask "font-rubik-puddles" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikpuddlesRubikPuddles-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Puddles"
  homepage "https:fonts.google.comspecimenRubik+Puddles"

  font "RubikPuddles-Regular.ttf"

  # No zap stanza required
end