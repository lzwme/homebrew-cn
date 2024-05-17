cask "font-spicy-rice" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflspicyriceSpicyRice-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Spicy Rice"
  homepage "https:fonts.google.comspecimenSpicy+Rice"

  font "SpicyRice-Regular.ttf"

  # No zap stanza required
end