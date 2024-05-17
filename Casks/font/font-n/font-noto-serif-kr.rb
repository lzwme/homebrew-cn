cask "font-noto-serif-kr" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifkrNotoSerifKR%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif KR"
  desc "Modulated (“serif”) design for the korean language"
  homepage "https:fonts.google.comspecimenNoto+Serif+KR"

  font "NotoSerifKR[wght].ttf"

  # No zap stanza required
end