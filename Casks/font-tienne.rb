cask "font-tienne" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltienne"
  name "Tienne"
  homepage "https:fonts.google.comspecimenTienne"

  font "Tienne-Black.ttf"
  font "Tienne-Bold.ttf"
  font "Tienne-Regular.ttf"

  # No zap stanza required
end