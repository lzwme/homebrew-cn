cask "font-bigshot-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbigshotoneBigshotOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bigshot One"
  homepage "https:fonts.google.comspecimenBigshot+One"

  font "BigshotOne-Regular.ttf"

  # No zap stanza required
end