cask "font-michroma" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmichromaMichroma-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Michroma"
  homepage "https:fonts.google.comspecimenMichroma"

  font "Michroma-Regular.ttf"

  # No zap stanza required
end