cask "font-bilbo-swash-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbilboswashcapsBilboSwashCaps-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Bilbo Swash Caps"
  homepage "https:fonts.google.comspecimenBilbo+Swash+Caps"

  font "BilboSwashCaps-Regular.ttf"

  # No zap stanza required
end