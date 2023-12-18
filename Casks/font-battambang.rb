cask "font-battambang" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbattambang"
  name "Battambang"
  homepage "https:fonts.google.comspecimenBattambang"

  font "Battambang-Black.ttf"
  font "Battambang-Bold.ttf"
  font "Battambang-Light.ttf"
  font "Battambang-Regular.ttf"
  font "Battambang-Thin.ttf"

  # No zap stanza required
end