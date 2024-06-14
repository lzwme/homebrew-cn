cask "font-tiro-kannada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirokannada"
  name "Tiro Kannada"
  homepage "https:fonts.google.comspecimenTiro+Kannada"

  font "TiroKannada-Italic.ttf"
  font "TiroKannada-Regular.ttf"

  # No zap stanza required
end