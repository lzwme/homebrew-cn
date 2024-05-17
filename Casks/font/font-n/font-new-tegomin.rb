cask "font-new-tegomin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnewtegominNewTegomin-Regular.ttf",
      verified: "github.comgooglefonts"
  name "New Tegomin"
  homepage "https:fonts.google.comspecimenNew+Tegomin"

  font "NewTegomin-Regular.ttf"

  # No zap stanza required
end