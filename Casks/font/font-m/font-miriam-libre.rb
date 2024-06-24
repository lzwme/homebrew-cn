cask "font-miriam-libre" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmiriamlibreMiriamLibre%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Miriam Libre"
  homepage "https:fonts.google.comspecimenMiriam+Libre"

  font "MiriamLibre[wght].ttf"

  # No zap stanza required
end