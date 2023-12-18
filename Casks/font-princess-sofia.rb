cask "font-princess-sofia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflprincesssofiaPrincessSofia-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Princess Sofia"
  homepage "https:fonts.google.comspecimenPrincess+Sofia"

  font "PrincessSofia-Regular.ttf"

  # No zap stanza required
end