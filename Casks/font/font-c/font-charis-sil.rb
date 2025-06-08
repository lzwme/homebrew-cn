cask "font-charis-sil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcharissil"
  name "Charis SIL"
  homepage "https:fonts.google.comspecimenCharis+SIL"

  font "CharisSIL-Bold.ttf"
  font "CharisSIL-BoldItalic.ttf"
  font "CharisSIL-Italic.ttf"
  font "CharisSIL-Regular.ttf"

  # No zap stanza required
end