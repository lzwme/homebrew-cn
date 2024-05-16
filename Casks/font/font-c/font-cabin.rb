cask "font-cabin" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcabin"
  name "Cabin"
  homepage "https:fonts.google.comspecimenCabin"

  font "Cabin-Italic[wdth,wght].ttf"
  font "Cabin[wdth,wght].ttf"

  # No zap stanza required
end