cask "font-rochester" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacherochesterRochester-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rochester"
  homepage "https:fonts.google.comspecimenRochester"

  font "Rochester-Regular.ttf"

  # No zap stanza required
end