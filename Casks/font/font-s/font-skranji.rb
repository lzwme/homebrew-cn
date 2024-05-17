cask "font-skranji" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflskranji"
  name "Skranji"
  homepage "https:fonts.google.comspecimenSkranji"

  font "Skranji-Bold.ttf"
  font "Skranji-Regular.ttf"

  # No zap stanza required
end