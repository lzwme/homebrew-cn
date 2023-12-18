cask "font-marvel" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmarvel"
  name "Marvel"
  homepage "https:fonts.google.comspecimenMarvel"

  font "Marvel-Bold.ttf"
  font "Marvel-BoldItalic.ttf"
  font "Marvel-Italic.ttf"
  font "Marvel-Regular.ttf"

  # No zap stanza required
end