cask "font-noto-serif-makasar" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifmakasarNotoSerifMakasar-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Makasar"
  homepage "https:fonts.google.comspecimenNoto+Serif+Makasar"

  font "NotoSerifMakasar-Regular.ttf"

  # No zap stanza required
end