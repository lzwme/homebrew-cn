cask "font-amita" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflamita"
  name "Amita"
  homepage "https:fonts.google.comspecimenAmita"

  font "Amita-Bold.ttf"
  font "Amita-Regular.ttf"

  # No zap stanza required
end