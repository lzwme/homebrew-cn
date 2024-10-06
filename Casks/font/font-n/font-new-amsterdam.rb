cask "font-new-amsterdam" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnewamsterdamNewAmsterdam-Regular.ttf",
      verified: "github.comgooglefonts"
  name "New Amsterdam"
  homepage "https:fonts.google.comspecimenNew+Amsterdam"

  font "NewAmsterdam-Regular.ttf"

  # No zap stanza required
end