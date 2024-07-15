cask "font-maname" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmanameManame-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Maname"
  homepage "https:fonts.google.comspecimenManame"

  font "Maname-Regular.ttf"

  # No zap stanza required
end