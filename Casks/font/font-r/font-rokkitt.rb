cask "font-rokkitt" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflrokkitt"
  name "Rokkitt"
  homepage "https:fonts.google.comspecimenRokkitt"

  font "Rokkitt-Italic[wght].ttf"
  font "Rokkitt[wght].ttf"

  # No zap stanza required
end