cask "font-corinthia" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcorinthia"
  name "Corinthia"
  homepage "https:fonts.google.comspecimenCorinthia"

  font "Corinthia-Bold.ttf"
  font "Corinthia-Regular.ttf"

  # No zap stanza required
end