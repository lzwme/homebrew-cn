cask "font-birthstone" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflbirthstoneBirthstone-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Birthstone"
  desc "Sibling birthstone bounce that includes caps and ending swashed forms"
  homepage "https:fonts.google.comspecimenBirthstone"

  font "Birthstone-Regular.ttf"

  # No zap stanza required
end