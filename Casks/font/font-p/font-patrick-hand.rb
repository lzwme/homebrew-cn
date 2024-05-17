cask "font-patrick-hand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflpatrickhandPatrickHand-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Patrick Hand"
  homepage "https:fonts.google.comspecimenPatrick+Hand"

  font "PatrickHand-Regular.ttf"

  # No zap stanza required
end