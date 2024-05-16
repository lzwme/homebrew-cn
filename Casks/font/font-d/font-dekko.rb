cask "font-dekko" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldekkoDekko-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Dekko"
  homepage "https:fonts.google.comspecimenDekko"

  font "Dekko-Regular.ttf"

  # No zap stanza required
end