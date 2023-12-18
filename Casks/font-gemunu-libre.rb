cask "font-gemunu-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgemunulibreGemunuLibre%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Gemunu Libre"
  homepage "https:fonts.google.comspecimenGemunu+Libre"

  font "GemunuLibre[wght].ttf"

  # No zap stanza required
end