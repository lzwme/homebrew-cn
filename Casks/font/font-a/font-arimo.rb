cask "font-arimo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "apachearimo"
  name "Arimo"
  homepage "https:fonts.google.comspecimenArimo"

  font "Arimo-Italic[wght].ttf"
  font "Arimo[wght].ttf"

  # No zap stanza required
end