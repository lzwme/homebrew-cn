cask "font-afacad-flux" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflafacadfluxAfacadFlux%5Bslnt%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Afacad Flux"
  homepage "https:fonts.google.comspecimenAfacad+Flux"

  font "AfacadFlux[slnt,wght].ttf"

  # No zap stanza required
end