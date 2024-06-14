cask "font-brygada-1918" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbrygada1918"
  name "Brygada 1918"
  homepage "https:fonts.google.comspecimenBrygada+1918"

  font "Brygada1918-Italic[wght].ttf"
  font "Brygada1918[wght].ttf"

  # No zap stanza required
end