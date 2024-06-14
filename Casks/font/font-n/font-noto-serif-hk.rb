cask "font-noto-serif-hk" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifhkNotoSerifHK%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif HK"
  homepage "https:fonts.google.comspecimenNoto+Serif+HK"

  font "NotoSerifHK[wght].ttf"

  # No zap stanza required
end