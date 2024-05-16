cask "font-bitter" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbitter"
  name "Bitter"
  desc "Slab-serif typeface optimized for e-ink screens"
  homepage "https:fonts.google.comspecimenBitter"

  font "Bitter-Italic[wght].ttf"
  font "Bitter[wght].ttf"

  # No zap stanza required
end