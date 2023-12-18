cask "font-nokora" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflnokora"
  name "Nokora"
  homepage "https:fonts.google.comspecimenNokora"

  font "Nokora-Black.ttf"
  font "Nokora-Bold.ttf"
  font "Nokora-Light.ttf"
  font "Nokora-Regular.ttf"
  font "Nokora-Thin.ttf"

  # No zap stanza required
end