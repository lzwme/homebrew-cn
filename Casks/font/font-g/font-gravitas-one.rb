cask "font-gravitas-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgravitasoneGravitasOne.ttf",
      verified: "github.comgooglefonts"
  name "Gravitas One"
  homepage "https:fonts.google.comspecimenGravitas+One"

  font "GravitasOne.ttf"

  # No zap stanza required
end