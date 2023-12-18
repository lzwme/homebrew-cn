cask "font-russo-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrussooneRussoOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Russo One"
  homepage "https:fonts.google.comspecimenRusso+One"

  font "RussoOne-Regular.ttf"

  # No zap stanza required
end