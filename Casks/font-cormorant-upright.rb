cask "font-cormorant-upright" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcormorantupright"
  name "Cormorant Upright"
  homepage "https:fonts.google.comspecimenCormorant+Upright"

  font "CormorantUpright-Bold.ttf"
  font "CormorantUpright-Light.ttf"
  font "CormorantUpright-Medium.ttf"
  font "CormorantUpright-Regular.ttf"
  font "CormorantUpright-SemiBold.ttf"

  # No zap stanza required
end