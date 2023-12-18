cask "font-indie-flower" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflindieflowerIndieFlower-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Indie Flower"
  homepage "https:fonts.google.comspecimenIndie+Flower"

  font "IndieFlower-Regular.ttf"

  # No zap stanza required
end