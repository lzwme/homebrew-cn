cask "font-noto-serif-yezidi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifyezidiNotoSerifYezidi%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Yezidi"
  homepage "https:fonts.google.comspecimenNoto+Serif+Yezidi"

  font "NotoSerifYezidi[wght].ttf"

  # No zap stanza required
end