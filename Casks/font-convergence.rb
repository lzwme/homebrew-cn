cask "font-convergence" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflconvergenceConvergence-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Convergence"
  homepage "https:fonts.google.comspecimenConvergence"

  font "Convergence-Regular.ttf"

  # No zap stanza required
end