cask "font-noto-serif-np-hmong" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifnphmongNotoSerifNPHmong%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif NP Hmong"
  homepage "https:fonts.google.comspecimenNoto+Serif+NP+Hmong"

  font "NotoSerifNPHmong[wght].ttf"

  # No zap stanza required
end