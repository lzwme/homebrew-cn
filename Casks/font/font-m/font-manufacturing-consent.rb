cask "font-manufacturing-consent" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmanufacturingconsentManufacturingConsent-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Manufacturing Consent"
  homepage "https:fonts.google.comspecimenManufacturing+Consent"

  font "ManufacturingConsent-Regular.ttf"

  # No zap stanza required
end