cask "font-the-girl-next-door" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflthegirlnextdoorTheGirlNextDoor.ttf",
      verified: "github.comgooglefonts"
  name "The Girl Next Door"
  homepage "https:fonts.google.comspecimenThe+Girl+Next+Door"

  font "TheGirlNextDoor.ttf"

  # No zap stanza required
end