cask "font-asap" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflasap"
  name "Asap"
  homepage "https:fonts.google.comspecimenAsap"

  font "Asap-Italic[wdth,wght].ttf"
  font "Asap[wdth,wght].ttf"

  # No zap stanza required
end