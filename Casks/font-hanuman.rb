cask "font-hanuman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflhanuman"
  name "Hanuman"
  homepage "https:fonts.google.comspecimenHanuman"

  font "Hanuman-Black.ttf"
  font "Hanuman-Bold.ttf"
  font "Hanuman-Light.ttf"
  font "Hanuman-Regular.ttf"
  font "Hanuman-Thin.ttf"

  # No zap stanza required
end