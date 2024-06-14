cask "font-noto-serif-khojki" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifkhojkiNotoSerifKhojki%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Khojki"
  homepage "https:fonts.google.comspecimenNoto+Serif+Khojki"

  font "NotoSerifKhojki[wght].ttf"

  # No zap stanza required
end