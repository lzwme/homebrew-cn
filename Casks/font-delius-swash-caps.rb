cask "font-delius-swash-caps" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldeliusswashcapsDeliusSwashCaps-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Delius Swash Caps"
  homepage "https:fonts.google.comspecimenDelius+Swash+Caps"

  font "DeliusSwashCaps-Regular.ttf"

  # No zap stanza required
end