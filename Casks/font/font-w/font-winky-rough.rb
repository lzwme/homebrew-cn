cask "font-winky-rough" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflwinkyrough"
  name "Winky Rough"
  homepage "https:fonts.google.comspecimenWinky+Rough"

  font "WinkyRough-Italic[wght].ttf"
  font "WinkyRough[wght].ttf"

  # No zap stanza required
end