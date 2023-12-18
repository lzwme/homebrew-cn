cask "font-lekton" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllekton"
  name "Lekton"
  homepage "https:fonts.google.comspecimenLekton"

  font "Lekton-Bold.ttf"
  font "Lekton-Italic.ttf"
  font "Lekton-Regular.ttf"

  # No zap stanza required
end