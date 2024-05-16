cask "font-fruktur" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflfruktur"
  name "Fruktur"
  homepage "https:fonts.google.comspecimenFruktur"

  font "Fruktur-Italic.ttf"
  font "Fruktur-Regular.ttf"

  # No zap stanza required
end