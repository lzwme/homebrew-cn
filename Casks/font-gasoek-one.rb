cask "font-gasoek-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgasoekoneGasoekOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gasoek One"
  homepage "https:fonts.google.comspecimenGasoek+One"

  font "GasoekOne-Regular.ttf"

  # No zap stanza required
end