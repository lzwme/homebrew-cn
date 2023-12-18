cask "font-square-peg" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsquarepegSquarePeg-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Square Peg"
  homepage "https:fonts.google.comspecimenSquare+Peg"

  font "SquarePeg-Regular.ttf"

  # No zap stanza required
end