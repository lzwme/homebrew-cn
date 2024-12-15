cask "font-noto-sans-phagspa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansphagspaNotoSansPhagsPa-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans PhagsPa"
  homepage "https:fonts.google.comspecimenNoto+Sans+PhagsPa"

  font "NotoSansPhagsPa-Regular.ttf"

  # No zap stanza required
end