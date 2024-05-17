cask "font-mada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmadaMada%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Mada"
  homepage "https:fonts.google.comspecimenMada"

  font "Mada[wght].ttf"

  # No zap stanza required
end