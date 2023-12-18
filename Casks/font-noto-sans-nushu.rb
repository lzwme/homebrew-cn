cask "font-noto-sans-nushu" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansnushuNotoSansNushu-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Nushu"
  homepage "https:fonts.google.comspecimenNoto+Sans+Nushu"

  font "NotoSansNushu-Regular.ttf"

  # No zap stanza required
end