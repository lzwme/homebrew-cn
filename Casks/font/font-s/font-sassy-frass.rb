cask "font-sassy-frass" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsassyfrassSassyFrass-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Sassy Frass"
  homepage "https:fonts.google.comspecimenSassy+Frass"

  font "SassyFrass-Regular.ttf"

  # No zap stanza required
end