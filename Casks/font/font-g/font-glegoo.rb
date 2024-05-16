cask "font-glegoo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflglegoo"
  name "Glegoo"
  homepage "https:fonts.google.comspecimenGlegoo"

  font "Glegoo-Bold.ttf"
  font "Glegoo-Regular.ttf"

  # No zap stanza required
end