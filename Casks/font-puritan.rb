cask "font-puritan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpuritan"
  name "Puritan"
  homepage "https:fonts.google.comspecimenPuritan"

  font "Puritan-Bold.ttf"
  font "Puritan-BoldItalic.ttf"
  font "Puritan-Italic.ttf"
  font "Puritan-Regular.ttf"

  # No zap stanza required
end