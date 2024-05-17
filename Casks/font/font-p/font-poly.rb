cask "font-poly" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflpoly"
  name "Poly"
  homepage "https:fonts.google.comspecimenPoly"

  font "Poly-Italic.ttf"
  font "Poly-Regular.ttf"

  # No zap stanza required
end