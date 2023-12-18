cask "font-poller-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpolleronePollerOne.ttf",
      verified: "github.comgooglefonts"
  name "Poller One"
  homepage "https:fonts.google.comspecimenPoller+One"

  font "PollerOne.ttf"

  # No zap stanza required
end