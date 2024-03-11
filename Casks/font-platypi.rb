cask "font-platypi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflplatypi"
  name "Platypi"
  desc "Platypuses"
  homepage "https:github.comd-sargentplatypi"

  font "Platypi-Italic[wght].ttf"
  font "Platypi[wght].ttf"

  # No zap stanza required
end