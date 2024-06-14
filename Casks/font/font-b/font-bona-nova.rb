cask "font-bona-nova" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbonanova"
  name "Bona Nova"
  homepage "https:fonts.google.comspecimenBona+Nova"

  font "BonaNova-Bold.ttf"
  font "BonaNova-Italic.ttf"
  font "BonaNova-Regular.ttf"

  # No zap stanza required
end