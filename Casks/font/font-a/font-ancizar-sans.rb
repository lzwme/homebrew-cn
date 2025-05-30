cask "font-ancizar-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflancizarsans"
  name "Ancizar Sans"
  homepage "https:fonts.google.comspecimenAncizar+Sans"

  font "AncizarSans-Italic[wght].ttf"
  font "AncizarSans[wght].ttf"

  # No zap stanza required
end