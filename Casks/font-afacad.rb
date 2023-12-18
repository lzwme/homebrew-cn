cask "font-afacad" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflafacad"
  name "Afacad"
  homepage "https:fonts.google.comspecimenAfacad"

  font "Afacad-Italic[wght].ttf"
  font "Afacad[wght].ttf"

  # No zap stanza required
end