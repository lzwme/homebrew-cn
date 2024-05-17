cask "font-noto-serif-grantha" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoserifgranthaNotoSerifGrantha-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Serif Grantha"
  homepage "https:fonts.google.comspecimenNoto+Serif+Grantha"

  font "NotoSerifGrantha-Regular.ttf"

  # No zap stanza required
end