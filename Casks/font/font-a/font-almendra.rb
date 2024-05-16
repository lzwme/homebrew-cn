cask "font-almendra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflalmendra"
  name "Almendra"
  homepage "https:fonts.google.comspecimenAlmendra"

  font "Almendra-Bold.ttf"
  font "Almendra-BoldItalic.ttf"
  font "Almendra-Italic.ttf"
  font "Almendra-Regular.ttf"

  # No zap stanza required
end