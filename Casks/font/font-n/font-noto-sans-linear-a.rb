cask "font-noto-sans-linear-a" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanslinearaNotoSansLinearA-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Linear A"
  homepage "https:fonts.google.comspecimenNoto+Sans+Linear+A"

  font "NotoSansLinearA-Regular.ttf"

  # No zap stanza required
end