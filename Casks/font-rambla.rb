cask "font-rambla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrambla"
  name "Rambla"
  homepage "https:fonts.google.comspecimenRambla"

  font "Rambla-Bold.ttf"
  font "Rambla-BoldItalic.ttf"
  font "Rambla-Italic.ttf"
  font "Rambla-Regular.ttf"

  # No zap stanza required
end