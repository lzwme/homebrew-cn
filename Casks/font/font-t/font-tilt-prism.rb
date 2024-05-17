cask "font-tilt-prism" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltiltprismTiltPrism%5BXROT%2CYROT%5D.ttf",
      verified: "github.comgooglefonts"
  name "Tilt Prism"
  homepage "https:fonts.google.comspecimenTilt+Prism"

  font "TiltPrism[XROT,YROT].ttf"

  # No zap stanza required
end