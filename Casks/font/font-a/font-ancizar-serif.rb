cask "font-ancizar-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflancizarserif"
  name "Ancizar Serif"
  homepage "https:fonts.google.comspecimenAncizar+Serif"

  font "AncizarSerif-Italic[wght].ttf"
  font "AncizarSerif[wght].ttf"

  # No zap stanza required
end