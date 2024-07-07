cask "font-bodoni-moda-sc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflbodonimodasc"
  name "Bodoni Moda SC"
  homepage "https:fonts.google.comspecimenBodoni+Moda+SC"

  font "BodoniModaSC-Italic[opsz,wght].ttf"
  font "BodoniModaSC[opsz,wght].ttf"

  # No zap stanza required
end