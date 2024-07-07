cask "font-bona-nova-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbonanovasc"
  name "Bona Nova SC"
  homepage "https:fonts.google.comspecimenBona+Nova+SC"

  font "BonaNovaSC-Bold.ttf"
  font "BonaNovaSC-Italic.ttf"
  font "BonaNovaSC-Regular.ttf"

  # No zap stanza required
end