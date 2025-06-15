cask "font-matangi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflmatangiMatangi%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Matangi"
  homepage "https:fonts.google.comspecimenMatangi"

  font "Matangi[wght].ttf"

  # No zap stanza required
end