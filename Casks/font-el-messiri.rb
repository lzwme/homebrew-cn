cask "font-el-messiri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflelmessiriElMessiri%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "El Messiri"
  homepage "https:fonts.google.comspecimenEl+Messiri"

  font "ElMessiri[wght].ttf"

  # No zap stanza required
end