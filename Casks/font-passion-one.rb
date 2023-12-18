cask "font-passion-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpassionone"
  name "Passion One"
  homepage "https:fonts.google.comspecimenPassion+One"

  font "PassionOne-Black.ttf"
  font "PassionOne-Bold.ttf"
  font "PassionOne-Regular.ttf"

  # No zap stanza required
end