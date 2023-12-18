cask "font-cormorant-unicase" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflcormorantunicase"
  name "Cormorant Unicase"
  homepage "https:fonts.google.comspecimenCormorant+Unicase"

  font "CormorantUnicase-Bold.ttf"
  font "CormorantUnicase-Light.ttf"
  font "CormorantUnicase-Medium.ttf"
  font "CormorantUnicase-Regular.ttf"
  font "CormorantUnicase-SemiBold.ttf"

  # No zap stanza required
end