cask "font-cherry-swash" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcherryswash"
  name "Cherry Swash"
  homepage "https:fonts.google.comspecimenCherry+Swash"

  font "CherrySwash-Bold.ttf"
  font "CherrySwash-Regular.ttf"

  # No zap stanza required
end