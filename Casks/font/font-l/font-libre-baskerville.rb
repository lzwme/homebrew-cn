cask "font-libre-baskerville" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllibrebaskerville"
  name "Libre Baskerville"
  homepage "https:fonts.google.comspecimenLibre+Baskerville"

  font "LibreBaskerville-Bold.ttf"
  font "LibreBaskerville-Italic.ttf"
  font "LibreBaskerville-Regular.ttf"

  # No zap stanza required
end