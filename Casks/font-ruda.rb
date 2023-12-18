cask "font-ruda" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflrudaRuda%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Ruda"
  homepage "https:fonts.google.comspecimenRuda"

  font "Ruda[wght].ttf"

  # No zap stanza required
end