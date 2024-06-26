cask "font-birthstone-bounce" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbirthstonebounce"
  name "Birthstone Bounce"
  homepage "https:fonts.google.comspecimenBirthstone+Bounce"

  font "BirthstoneBounce-Medium.ttf"
  font "BirthstoneBounce-Regular.ttf"

  # No zap stanza required
end