cask "font-expletus-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflexpletussans"
  name "Expletus Sans"
  homepage "https:fonts.google.comspecimenExpletus+Sans"

  font "ExpletusSans-Italic[wght].ttf"
  font "ExpletusSans[wght].ttf"

  # No zap stanza required
end