cask "font-chonburi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflchonburiChonburi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Chonburi"
  homepage "https:fonts.google.comspecimenChonburi"

  font "Chonburi-Regular.ttf"

  # No zap stanza required
end