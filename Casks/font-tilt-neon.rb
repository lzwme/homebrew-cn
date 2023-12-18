cask "font-tilt-neon" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltiltneonTiltNeon%5BXROT%2CYROT%5D.ttf",
      verified: "github.comgooglefonts"
  name "Tilt Neon"
  homepage "https:fonts.google.comspecimenTilt+Neon"

  font "TiltNeon[XROT,YROT].ttf"

  # No zap stanza required
end