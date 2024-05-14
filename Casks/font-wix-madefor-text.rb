cask "font-wix-madefor-text" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflwixmadefortext"
  name "Wix Madefor Text"
  homepage "https:fonts.google.comspecimenWix+Madefor+Text"

  font "WixMadeforText[wght].ttf"
  font "WixMadeforText-Italic[wght].ttf"

  # No zap stanza required
end