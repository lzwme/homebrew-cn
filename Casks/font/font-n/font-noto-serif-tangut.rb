cask "font-noto-serif-tangut" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoseriftangutNotoSerifTangut-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Tangut"
  homepage "https:fonts.google.comspecimenNoto+Serif+Tangut"

  font "NotoSerifTangut-Regular.ttf"

  # No zap stanza required
end