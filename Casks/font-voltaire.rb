cask "font-voltaire" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflvoltaireVoltaire-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Voltaire"
  homepage "https:fonts.google.comspecimenVoltaire"

  font "Voltaire-Regular.ttf"

  # No zap stanza required
end