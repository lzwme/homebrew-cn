cask "font-rubik-beastly" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikbeastlyRubikBeastly-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Beastly"
  desc "Based on the google fonts rubik by hubert and fischer, meir sadan and cyreal"
  homepage "https:fonts.google.comspecimenRubik+Beastly"

  font "RubikBeastly-Regular.ttf"

  # No zap stanza required
end