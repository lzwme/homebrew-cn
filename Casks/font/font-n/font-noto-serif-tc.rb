cask "font-noto-serif-tc" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoseriftcNotoSerifTC%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif TC"
  homepage "https:fonts.google.comspecimenNoto+Serif+TC"

  font "NotoSerifTC[wght].ttf"

  # No zap stanza required
end