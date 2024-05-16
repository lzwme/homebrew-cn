cask "font-chathura" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflchathura"
  name "Chathura"
  homepage "https:fonts.google.comspecimenChathura"

  font "Chathura-Bold.ttf"
  font "Chathura-ExtraBold.ttf"
  font "Chathura-Light.ttf"
  font "Chathura-Regular.ttf"
  font "Chathura-Thin.ttf"

  # No zap stanza required
end