cask "font-rubik-pixels" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrubikpixelsRubikPixels-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Rubik Pixels"
  homepage "https:fonts.google.comspecimenRubik+Pixels"

  font "RubikPixels-Regular.ttf"

  # No zap stanza required
end