cask "font-linden-hill" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllindenhill"
  name "Linden Hill"
  homepage "https:fonts.google.comspecimenLinden+Hill"

  font "LindenHill-Italic.ttf"
  font "LindenHill-Regular.ttf"

  # No zap stanza required
end