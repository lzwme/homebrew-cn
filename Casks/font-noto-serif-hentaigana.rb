cask "font-noto-serif-hentaigana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifhentaiganaNotoSerifHentaigana%5Bwght%5D.ttf"
  name "Noto Serif Hentaigana"
  desc "Font that contains symbols for the kana supplement unicode block"
  homepage "https:github.comnotofontshentaigana.git"

  font "NotoSerifHentaigana[wght].ttf"

  # No zap stanza required
end