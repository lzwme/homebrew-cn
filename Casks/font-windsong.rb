cask "font-windsong" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflwindsong"
  name "WindSong"
  desc "Elongated script with multiple stylistic sets"
  homepage "https:fonts.google.comspecimenWindSong"

  font "WindSong-Medium.ttf"
  font "WindSong-Regular.ttf"

  # No zap stanza required
end