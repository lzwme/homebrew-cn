cask "font-delius" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldeliusDelius-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Delius"
  homepage "https:fonts.google.comspecimenDelius"

  font "Delius-Regular.ttf"

  # No zap stanza required
end