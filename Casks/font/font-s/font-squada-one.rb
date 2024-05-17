cask "font-squada-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsquadaoneSquadaOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Squada One"
  homepage "https:fonts.google.comspecimenSquada+One"

  font "SquadaOne-Regular.ttf"

  # No zap stanza required
end