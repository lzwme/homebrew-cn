cask "font-moirai-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmoiraioneMoiraiOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Moirai One"
  homepage "https:fonts.google.comspecimenMoirai+One"

  font "MoiraiOne-Regular.ttf"

  # No zap stanza required
end