cask "font-gudea" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgudea"
  name "Gudea"
  homepage "https:fonts.google.comspecimenGudea"

  font "Gudea-Bold.ttf"
  font "Gudea-Italic.ttf"
  font "Gudea-Regular.ttf"

  # No zap stanza required
end