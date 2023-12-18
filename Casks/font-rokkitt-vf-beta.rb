cask "font-rokkitt-vf-beta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrokkittvfbetaRokkittVFBeta.ttf",
      verified: "github.comgooglefonts"
  name "Rokkitt VF Beta"
  homepage "https:fonts.google.comspecimenRokkitt+VF+Beta"

  font "RokkittVFBeta.ttf"

  # No zap stanza required
end