cask "font-noto-sans-wancho" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanswanchoNotoSansWancho-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Wancho"
  homepage "https:fonts.google.comspecimenNoto+Sans+Wancho"

  font "NotoSansWancho-Regular.ttf"

  # No zap stanza required
end