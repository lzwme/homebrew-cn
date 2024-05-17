cask "font-noto-sans-grantha" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansgranthaNotoSansGrantha-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Grantha"
  homepage "https:fonts.google.comspecimenNoto+Sans+Grantha"

  font "NotoSansGrantha-Regular.ttf"

  # No zap stanza required
end