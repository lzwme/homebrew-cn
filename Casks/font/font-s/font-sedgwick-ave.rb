cask "font-sedgwick-ave" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsedgwickaveSedgwickAve-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sedgwick Ave"
  homepage "https:fonts.google.comspecimenSedgwick+Ave"

  font "SedgwickAve-Regular.ttf"

  # No zap stanza required
end