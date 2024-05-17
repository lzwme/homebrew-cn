cask "font-scada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflscada"
  name "Scada"
  homepage "https:fonts.google.comspecimenScada"

  font "Scada-Bold.ttf"
  font "Scada-BoldItalic.ttf"
  font "Scada-Italic.ttf"
  font "Scada-Regular.ttf"

  # No zap stanza required
end