cask "font-wavefont" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflwavefontWavefont%5BROND%2CYELA%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Wavefont"
  homepage "https:fonts.google.comspecimenWavefont"

  font "Wavefont[ROND,YELA,wght].ttf"

  # No zap stanza required
end