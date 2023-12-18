cask "font-mohave" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflmohave"
  name "Mohave"
  homepage "https:fonts.google.comspecimenMohave"

  font "Mohave-Italic[wght].ttf"
  font "Mohave[wght].ttf"

  # No zap stanza required
end