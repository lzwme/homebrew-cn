cask "font-gupter" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgupter"
  name "Gupter"
  homepage "https:fonts.google.comspecimenGupter"

  font "Gupter-Bold.ttf"
  font "Gupter-Medium.ttf"
  font "Gupter-Regular.ttf"

  # No zap stanza required
end