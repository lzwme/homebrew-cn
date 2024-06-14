cask "font-bitter" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbitter"
  name "Bitter"
  homepage "https:fonts.google.comspecimenBitter"

  font "Bitter-Italic[wght].ttf"
  font "Bitter[wght].ttf"

  # No zap stanza required
end