cask "font-carrois-gothic-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcarroisgothicscCarroisGothicSC-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Carrois Gothic SC"
  homepage "https:fonts.google.comspecimenCarrois+Gothic+SC"

  font "CarroisGothicSC-Regular.ttf"

  # No zap stanza required
end