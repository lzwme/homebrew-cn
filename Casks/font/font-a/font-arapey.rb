cask "font-arapey" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarapey"
  name "Arapey"
  homepage "https:fonts.google.comspecimenArapey"

  font "Arapey-Italic.ttf"
  font "Arapey-Regular.ttf"

  # No zap stanza required
end