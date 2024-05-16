cask "font-cousine" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apachecousine"
  name "Cousine"
  homepage "https:fonts.google.comspecimenCousine"

  font "Cousine-Bold.ttf"
  font "Cousine-BoldItalic.ttf"
  font "Cousine-Italic.ttf"
  font "Cousine-Regular.ttf"

  # No zap stanza required
end