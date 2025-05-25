cask "font-hanuman" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflhanumanHanuman%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Hanuman"
  homepage "https:fonts.google.comspecimenHanuman"

  font "Hanuman[wght].ttf"

  # No zap stanza required
end