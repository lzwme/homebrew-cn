cask "font-stix-two-math" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstixtwomathSTIXTwoMath-Regular.ttf",
      verified: "github.comgooglefonts"
  name "STIX Two Math"
  homepage "https:fonts.google.comspecimenSTIX+Two+Math"

  font "STIXTwoMath-Regular.ttf"

  # No zap stanza required
end