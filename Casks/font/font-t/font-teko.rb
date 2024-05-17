cask "font-teko" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltekoTeko%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Teko"
  homepage "https:fonts.google.comspecimenTeko"

  font "Teko[wght].ttf"

  # No zap stanza required
end