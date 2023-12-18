cask "font-quattrocento-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefonts.git",
      verified:  "github.comgooglefonts",
      branch:    "main",
      only_path: "oflquattrocentosans"
  name "Quattrocento Sans"
  homepage "https:fonts.google.comspecimenQuattrocento+Sans"

  font "QuattrocentoSans-Bold.ttf"
  font "QuattrocentoSans-BoldItalic.ttf"
  font "QuattrocentoSans-Italic.ttf"
  font "QuattrocentoSans-Regular.ttf"

  # No zap stanza required
end