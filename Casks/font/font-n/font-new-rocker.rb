cask "font-new-rocker" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnewrockerNewRocker-Regular.ttf",
      verified: "github.comgooglefonts"
  name "New Rocker"
  homepage "https:fonts.google.comspecimenNew+Rocker"

  font "NewRocker-Regular.ttf"

  # No zap stanza required
end