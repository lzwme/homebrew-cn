cask "font-linefont" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofllinefontLinefont%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Linefont"
  homepage "https:fonts.google.comspecimenLinefont"

  font "Linefont[wdth,wght].ttf"

  # No zap stanza required
end