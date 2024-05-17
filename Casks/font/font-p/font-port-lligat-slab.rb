cask "font-port-lligat-slab" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflportlligatslabPortLligatSlab-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Port Lligat Slab"
  homepage "https:fonts.google.comspecimenPort+Lligat+Slab"

  font "PortLligatSlab-Regular.ttf"

  # No zap stanza required
end