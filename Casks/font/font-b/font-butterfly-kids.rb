cask "font-butterfly-kids" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbutterflykidsButterflyKids-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Butterfly Kids"
  homepage "https:fonts.google.comspecimenButterfly+Kids"

  font "ButterflyKids-Regular.ttf"

  # No zap stanza required
end