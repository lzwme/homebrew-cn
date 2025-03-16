cask "font-winky-rough" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      branch:    "main",
      only_path: "oflwinkyrough"
  name "Winky Rough"
  homepage "https:github.comtypofacturwinkyrough"

  font "WinkyRough-Italic[wght].ttf"
  font "WinkyRough[wght].ttf"

  # No zap stanza required
end