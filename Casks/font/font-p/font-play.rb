cask "font-play" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplay"
  name "Play"
  homepage "https:fonts.google.comspecimenPlay"

  font "Play-Bold.ttf"
  font "Play-Regular.ttf"

  # No zap stanza required
end