cask "font-digital-numbers" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldigitalnumbersDigitalNumbers-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Digital Numbers"
  homepage "https:fonts.google.comspecimenDigital+Numbers"

  font "DigitalNumbers-Regular.ttf"

  # No zap stanza required
end