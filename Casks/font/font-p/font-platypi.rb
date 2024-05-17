cask "font-platypi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflplatypi"
  name "Platypi"
  desc "Platypuses"
  homepage "https:fonts.google.comspecimenPlatypi"

  font "Platypi-Italic[wght].ttf"
  font "Platypi[wght].ttf"

  # No zap stanza required
end