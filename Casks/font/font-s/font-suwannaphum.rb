cask "font-suwannaphum" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsuwannaphum"
  name "Suwannaphum"
  homepage "https:fonts.google.comspecimenSuwannaphum"

  font "Suwannaphum-Black.ttf"
  font "Suwannaphum-Bold.ttf"
  font "Suwannaphum-Light.ttf"
  font "Suwannaphum-Regular.ttf"
  font "Suwannaphum-Thin.ttf"

  # No zap stanza required
end