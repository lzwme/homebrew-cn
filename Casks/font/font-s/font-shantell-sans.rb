cask "font-shantell-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflshantellsans"
  name "Shantell Sans"
  homepage "https:fonts.google.comspecimenShantell+Sans"

  font "ShantellSans-Italic[BNCE,INFM,SPAC,wght].ttf"
  font "ShantellSans[BNCE,INFM,SPAC,wght].ttf"

  # No zap stanza required
end