cask "font-tilt-warp" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltiltwarpTiltWarp%5BXROT%2CYROT%5D.ttf",
      verified: "github.comgooglefonts"
  name "Tilt Warp"
  homepage "https:fonts.google.comspecimenTilt+Warp"

  font "TiltWarp[XROT,YROT].ttf"

  # No zap stanza required
end