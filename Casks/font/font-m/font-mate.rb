cask "font-mate" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmate"
  name "Mate"
  homepage "https:fonts.google.comspecimenMate"

  font "Mate-Italic.ttf"
  font "Mate-Regular.ttf"

  # No zap stanza required
end