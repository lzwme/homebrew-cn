cask "font-pirata-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpirataonePirataOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Pirata One"
  homepage "https:fonts.google.comspecimenPirata+One"

  font "PirataOne-Regular.ttf"

  # No zap stanza required
end