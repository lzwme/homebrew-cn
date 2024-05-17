cask "font-petrona" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpetrona"
  name "Petrona"
  homepage "https:fonts.google.comspecimenPetrona"

  font "Petrona-Italic[wght].ttf"
  font "Petrona[wght].ttf"

  # No zap stanza required
end