cask "font-domine" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofldomineDomine%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Domine"
  homepage "https:fonts.google.comspecimenDomine"

  font "Domine[wght].ttf"

  # No zap stanza required
end