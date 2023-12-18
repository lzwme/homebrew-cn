cask "font-staatliches" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflstaatlichesStaatliches-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Staatliches"
  homepage "https:fonts.google.comspecimenStaatliches"

  font "Staatliches-Regular.ttf"

  # No zap stanza required
end