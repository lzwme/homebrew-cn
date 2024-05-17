cask "font-piazzolla" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpiazzolla"
  name "Piazzolla"
  desc "Serif font family for media"
  homepage "https:fonts.google.comspecimenPiazzolla"

  font "Piazzolla-Italic[opsz,wght].ttf"
  font "Piazzolla[opsz,wght].ttf"

  # No zap stanza required
end