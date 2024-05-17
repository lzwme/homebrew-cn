cask "font-miltonian" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmiltonianMiltonian-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Miltonian"
  homepage "https:fonts.google.comspecimenMiltonian"

  font "Miltonian-Regular.ttf"

  # No zap stanza required
end