cask "font-arvo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflarvo"
  name "Arvo"
  homepage "https:fonts.google.comspecimenArvo"

  font "Arvo-Bold.ttf"
  font "Arvo-BoldItalic.ttf"
  font "Arvo-Italic.ttf"
  font "Arvo-Regular.ttf"

  # No zap stanza required
end