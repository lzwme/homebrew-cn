cask "font-bubbler-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbubbleroneBubblerOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bubbler One"
  homepage "https:fonts.google.comspecimenBubbler+One"

  font "BubblerOne-Regular.ttf"

  # No zap stanza required
end