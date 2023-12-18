cask "font-macondo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmacondoMacondo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Macondo"
  homepage "https:fonts.google.comspecimenMacondo"

  font "Macondo-Regular.ttf"

  # No zap stanza required
end