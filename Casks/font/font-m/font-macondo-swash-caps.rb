cask "font-macondo-swash-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmacondoswashcapsMacondoSwashCaps-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Macondo Swash Caps"
  homepage "https:fonts.google.comspecimenMacondo+Swash+Caps"

  font "MacondoSwashCaps-Regular.ttf"

  # No zap stanza required
end