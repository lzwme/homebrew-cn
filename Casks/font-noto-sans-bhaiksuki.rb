cask "font-noto-sans-bhaiksuki" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansbhaiksukiNotoSansBhaiksuki-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Bhaiksuki"
  homepage "https:fonts.google.comspecimenNoto+Sans+Bhaiksuki"

  font "NotoSansBhaiksuki-Regular.ttf"

  # No zap stanza required
end