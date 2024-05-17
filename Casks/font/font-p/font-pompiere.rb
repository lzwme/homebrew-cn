cask "font-pompiere" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpompierePompiere-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pompiere"
  homepage "https:fonts.google.comspecimenPompiere"

  font "Pompiere-Regular.ttf"

  # No zap stanza required
end