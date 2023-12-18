cask "font-schoolbell" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainapacheschoolbellSchoolbell-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Schoolbell"
  homepage "https:fonts.google.comspecimenSchoolbell"

  font "Schoolbell-Regular.ttf"

  # No zap stanza required
end