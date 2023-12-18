cask "font-stylish" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstylishStylish-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Stylish"
  homepage "https:fonts.google.comspecimenStylish"

  font "Stylish-Regular.ttf"

  # No zap stanza required
end