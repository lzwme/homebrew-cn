cask "font-caudex" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcaudex"
  name "Caudex"
  homepage "https:fonts.google.comspecimenCaudex"

  font "Caudex-Bold.ttf"
  font "Caudex-BoldItalic.ttf"
  font "Caudex-Italic.ttf"
  font "Caudex-Regular.ttf"

  # No zap stanza required
end