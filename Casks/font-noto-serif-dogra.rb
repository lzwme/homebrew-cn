cask "font-noto-serif-dogra" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifdograNotoSerifDogra-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Dogra"
  homepage "https:fonts.google.comspecimenNoto+Serif+Dogra"

  font "NotoSerifDogra-Regular.ttf"

  # No zap stanza required
end