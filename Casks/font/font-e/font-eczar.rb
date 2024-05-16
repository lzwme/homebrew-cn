cask "font-eczar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofleczarEczar%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Eczar"
  homepage "https:fonts.google.comspecimenEczar"

  font "Eczar[wght].ttf"

  # No zap stanza required
end