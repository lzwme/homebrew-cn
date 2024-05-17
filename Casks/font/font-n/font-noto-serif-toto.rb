cask "font-noto-serif-toto" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoseriftotoNotoSerifToto%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Toto"
  homepage "https:fonts.google.comspecimenNoto+Serif+Toto"

  font "NotoSerifToto[wght].ttf"

  # No zap stanza required
end