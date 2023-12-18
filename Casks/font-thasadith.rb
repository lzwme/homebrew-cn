cask "font-thasadith" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflthasadith"
  name "Thasadith"
  homepage "https:fonts.google.comspecimenThasadith"

  font "Thasadith-Bold.ttf"
  font "Thasadith-BoldItalic.ttf"
  font "Thasadith-Italic.ttf"
  font "Thasadith-Regular.ttf"

  # No zap stanza required
end