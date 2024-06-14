cask "font-tiro-tamil" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "ofltirotamil"
  name "Tiro Tamil"
  homepage "https:fonts.google.comspecimenTiro+Tamil"

  font "TiroTamil-Italic.ttf"
  font "TiroTamil-Regular.ttf"

  # No zap stanza required
end