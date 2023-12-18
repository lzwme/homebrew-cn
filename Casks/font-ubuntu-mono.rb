cask "font-ubuntu-mono" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "uflubuntumono"
  name "Ubuntu Mono"
  homepage "https:fonts.google.comspecimenUbuntu+Mono"

  font "UbuntuMono-Bold.ttf"
  font "UbuntuMono-BoldItalic.ttf"
  font "UbuntuMono-Italic.ttf"
  font "UbuntuMono-Regular.ttf"

  # No zap stanza required
end