cask "font-carrois-gothic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcarroisgothicCarroisGothic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Carrois Gothic"
  homepage "https:fonts.google.comspecimenCarrois+Gothic"

  font "CarroisGothic-Regular.ttf"

  # No zap stanza required
end