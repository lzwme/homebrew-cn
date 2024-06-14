cask "font-andada-pro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflandadapro"
  name "Andada Pro"
  homepage "https:fonts.google.comspecimenAndada+Pro"

  font "AndadaPro-Italic[wght].ttf"
  font "AndadaPro[wght].ttf"

  # No zap stanza required
end