cask "font-noto-sans-newa" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansnewaNotoSansNewa-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Newa"
  homepage "https:fonts.google.comspecimenNoto+Sans+Newa"

  font "NotoSansNewa-Regular.ttf"

  # No zap stanza required
end