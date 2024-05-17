cask "font-wire-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwireoneWireOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Wire One"
  homepage "https:fonts.google.comspecimenWire+One"

  font "WireOne-Regular.ttf"

  # No zap stanza required
end