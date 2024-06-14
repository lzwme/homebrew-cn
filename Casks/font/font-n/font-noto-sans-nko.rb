cask "font-noto-sans-nko" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansnkoNotoSansNKo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans NKo"
  homepage "https:fonts.google.comspecimenNoto+Sans+NKo"

  font "NotoSansNKo-Regular.ttf"

  # No zap stanza required
end