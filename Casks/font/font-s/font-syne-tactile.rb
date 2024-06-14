cask "font-syne-tactile" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsynetactileSyneTactile-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Syne Tactile"
  homepage "https:fonts.google.comspecimenSyne+Tactile"

  font "SyneTactile-Regular.ttf"

  # No zap stanza required
end