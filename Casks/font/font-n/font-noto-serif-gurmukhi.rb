cask "font-noto-serif-gurmukhi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifgurmukhiNotoSerifGurmukhi%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Gurmukhi"
  homepage "https:fonts.google.comspecimenNoto+Serif+Gurmukhi"

  font "NotoSerifGurmukhi[wght].ttf"

  # No zap stanza required
end