cask "font-boldonse" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflboldonseBoldonse-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Boldonse"
  homepage "https:fonts.google.comspecimenBoldonse"

  font "Boldonse-Regular.ttf"

  # No zap stanza required
end