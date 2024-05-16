cask "font-caveat-brush" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflcaveatbrushCaveatBrush-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Caveat Brush"
  homepage "https:fonts.google.comspecimenCaveat+Brush"

  font "CaveatBrush-Regular.ttf"

  # No zap stanza required
end