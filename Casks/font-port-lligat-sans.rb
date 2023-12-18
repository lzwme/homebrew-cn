cask "font-port-lligat-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflportlligatsansPortLligatSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Port Lligat Sans"
  homepage "https:fonts.google.comspecimenPort+Lligat+Sans"

  font "PortLligatSans-Regular.ttf"

  # No zap stanza required
end