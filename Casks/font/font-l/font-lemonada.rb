cask "font-lemonada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllemonadaLemonada%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Lemonada"
  homepage "https:fonts.google.comspecimenLemonada"

  font "Lemonada[wght].ttf"

  # No zap stanza required
end