cask "font-gantari" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflgantari"
  name "Gantari"
  homepage "https:fonts.google.comspecimenGantari"

  font "Gantari-Italic[wght].ttf"
  font "Gantari[wght].ttf"

  # No zap stanza required
end