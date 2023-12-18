cask "font-allan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflallan"
  name "Allan"
  homepage "https:fonts.google.comspecimenAllan"

  font "Allan-Bold.ttf"
  font "Allan-Regular.ttf"

  # No zap stanza required
end