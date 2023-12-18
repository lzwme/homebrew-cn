cask "font-noto-sans-soyombo" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssoyomboNotoSansSoyombo-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Soyombo"
  homepage "https:fonts.google.comspecimenNoto+Sans+Soyombo"

  font "NotoSansSoyombo-Regular.ttf"

  # No zap stanza required
end