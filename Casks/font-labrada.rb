cask "font-labrada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofllabrada"
  name "Labrada"
  homepage "https:fonts.google.comspecimenLabrada"

  font "Labrada-Italic[wght].ttf"
  font "Labrada[wght].ttf"

  # No zap stanza required
end