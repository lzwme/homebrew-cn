cask "font-boogaloo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflboogalooBoogaloo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Boogaloo"
  homepage "https:fonts.google.comspecimenBoogaloo"

  font "Boogaloo-Regular.ttf"

  # No zap stanza required
end