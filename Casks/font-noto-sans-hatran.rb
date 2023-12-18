cask "font-noto-sans-hatran" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanshatranNotoSansHatran-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Hatran"
  homepage "https:fonts.google.comspecimenNoto+Sans+Hatran"

  font "NotoSansHatran-Regular.ttf"

  # No zap stanza required
end