cask "font-bubblegum-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbubblegumsansBubblegumSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bubblegum Sans"
  homepage "https:fonts.google.comspecimenBubblegum+Sans"

  font "BubblegumSans-Regular.ttf"

  # No zap stanza required
end