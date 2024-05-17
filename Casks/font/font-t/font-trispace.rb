cask "font-trispace" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltrispaceTrispace%5Bwdth%2Cwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Trispace"
  desc "Designed by tyler finck (etc)"
  homepage "https:fonts.google.comspecimenTrispace"

  font "Trispace[wdth,wght].ttf"

  # No zap stanza required
end