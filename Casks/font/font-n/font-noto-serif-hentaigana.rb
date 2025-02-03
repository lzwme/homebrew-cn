cask "font-noto-serif-hentaigana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifhentaiganaNotoSerifHentaigana%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Hentaigana"
  homepage "https:fonts.google.comspecimenNoto+Serif+Hentaigana"

  font "NotoSerifHentaigana[wght].ttf"

  # No zap stanza required
end