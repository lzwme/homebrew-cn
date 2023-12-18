cask "font-quantico" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflquantico"
  name "Quantico"
  homepage "https:fonts.google.comspecimenQuantico"

  font "Quantico-Bold.ttf"
  font "Quantico-BoldItalic.ttf"
  font "Quantico-Italic.ttf"
  font "Quantico-Regular.ttf"

  # No zap stanza required
end