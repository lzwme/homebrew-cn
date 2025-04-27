cask "font-coral-pixels" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcoralpixelsCoralPixels-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Coral Pixels"
  homepage "https:fonts.google.comspecimenCoral+Pixels"

  font "CoralPixels-Regular.ttf"

  # No zap stanza required
end