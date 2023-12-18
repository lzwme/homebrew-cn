cask "font-risque" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrisqueRisque-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Risque"
  homepage "https:fonts.google.comspecimenRisque"

  font "Risque-Regular.ttf"

  # No zap stanza required
end