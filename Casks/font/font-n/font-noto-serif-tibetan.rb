cask "font-noto-serif-tibetan" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoseriftibetanNotoSerifTibetan%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Tibetan"
  homepage "https:fonts.google.comspecimenNoto+Serif+Tibetan"

  font "NotoSerifTibetan[wght].ttf"

  # No zap stanza required
end