cask "font-alkatra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflalkatraAlkatra%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Alkatra"
  homepage "https:fonts.google.comspecimenAlkatra"

  font "Alkatra[wght].ttf"

  # No zap stanza required
end