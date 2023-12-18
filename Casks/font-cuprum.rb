cask "font-cuprum" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcuprum"
  name "Cuprum"
  homepage "https:fonts.google.comspecimenCuprum"

  font "Cuprum-Italic[wght].ttf"
  font "Cuprum[wght].ttf"

  # No zap stanza required
end