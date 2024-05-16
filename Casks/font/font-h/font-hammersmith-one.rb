cask "font-hammersmith-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhammersmithoneHammersmithOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Hammersmith One"
  homepage "https:fonts.google.comspecimenHammersmith+One"

  font "HammersmithOne-Regular.ttf"

  # No zap stanza required
end