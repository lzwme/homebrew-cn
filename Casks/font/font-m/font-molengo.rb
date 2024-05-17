cask "font-molengo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmolengoMolengo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Molengo"
  homepage "https:fonts.google.comspecimenMolengo"

  font "Molengo-Regular.ttf"

  # No zap stanza required
end