cask "font-kapakana" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflkapakanaKapakana%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Kapakana"
  desc "Two weight font and available both as static instances and as a variable font"
  homepage "https:fonts.google.comspecimenKapakana"

  font "Kapakana[wght].ttf"

  # No zap stanza required
end