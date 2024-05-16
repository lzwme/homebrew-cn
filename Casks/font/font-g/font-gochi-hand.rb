cask "font-gochi-hand" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgochihandGochiHand-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gochi Hand"
  homepage "https:fonts.google.comspecimenGochi+Hand"

  font "GochiHand-Regular.ttf"

  # No zap stanza required
end