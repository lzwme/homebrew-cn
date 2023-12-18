cask "font-yrsa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflyrsa"
  name "Yrsa"
  homepage "https:fonts.google.comspecimenYrsa"

  font "Yrsa-Italic[wght].ttf"
  font "Yrsa[wght].ttf"

  # No zap stanza required
end