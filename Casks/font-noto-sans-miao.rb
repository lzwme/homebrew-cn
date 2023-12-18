cask "font-noto-sans-miao" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmiaoNotoSansMiao-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Miao"
  homepage "https:fonts.google.comspecimenNoto+Sans+Miao"

  font "NotoSansMiao-Regular.ttf"

  # No zap stanza required
end