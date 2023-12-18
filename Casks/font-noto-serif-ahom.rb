cask "font-noto-serif-ahom" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifahomNotoSerifAhom-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Ahom"
  homepage "https:fonts.google.comspecimenNoto+Serif+Ahom"

  font "NotoSerifAhom-Regular.ttf"

  # No zap stanza required
end