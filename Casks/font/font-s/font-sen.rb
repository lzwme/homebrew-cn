cask "font-sen" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflsenSen%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Sen"
  homepage "https:fonts.google.comspecimenSen"

  font "Sen[wght].ttf"

  # No zap stanza required
end