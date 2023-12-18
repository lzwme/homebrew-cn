cask "font-phudu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflphuduPhudu%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Phudu"
  homepage "https:fonts.google.comspecimenPhudu"

  font "Phudu[wght].ttf"

  # No zap stanza required
end