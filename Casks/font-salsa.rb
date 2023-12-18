cask "font-salsa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsalsaSalsa-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Salsa"
  homepage "https:fonts.google.comspecimenSalsa"

  font "Salsa-Regular.ttf"

  # No zap stanza required
end