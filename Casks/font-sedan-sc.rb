cask "font-sedan-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsedanscSedanSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sedan SC"
  homepage "https:fonts.google.comspecimenSedan+SC"

  font "SedanSC-Regular.ttf"

  # No zap stanza required
end