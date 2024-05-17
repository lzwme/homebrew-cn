cask "font-nats" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnatsNATS-Regular.ttf",
      verified: "github.comgooglefonts"
  name "NATS"
  homepage "https:fonts.google.comspecimenNATS"

  font "NATS-Regular.ttf"

  # No zap stanza required
end