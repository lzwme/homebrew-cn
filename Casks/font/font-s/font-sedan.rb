cask "font-sedan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflsedan"
  name "Sedan"
  homepage "https:fonts.google.comspecimenSedan"

  font "Sedan-Italic.ttf"
  font "Sedan-Regular.ttf"

  # No zap stanza required
end