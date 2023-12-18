cask "font-galada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgaladaGalada-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Galada"
  homepage "https:fonts.google.comspecimenGalada"

  font "Galada-Regular.ttf"

  # No zap stanza required
end