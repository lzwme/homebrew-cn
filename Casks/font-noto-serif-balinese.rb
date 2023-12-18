cask "font-noto-serif-balinese" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifbalineseNotoSerifBalinese-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Balinese"
  homepage "https:fonts.google.comspecimenNoto+Serif+Balinese"

  font "NotoSerifBalinese-Regular.ttf"

  # No zap stanza required
end