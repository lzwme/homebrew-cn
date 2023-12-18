cask "font-almarai" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalmarai"
  name "Almarai"
  homepage "https:fonts.google.comspecimenAlmarai"

  font "Almarai-Bold.ttf"
  font "Almarai-ExtraBold.ttf"
  font "Almarai-Light.ttf"
  font "Almarai-Regular.ttf"

  # No zap stanza required
end