cask "font-noto-sans-tirhuta" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanstirhutaNotoSansTirhuta-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Tirhuta"
  homepage "https:fonts.google.comspecimenNoto+Sans+Tirhuta"

  font "NotoSansTirhuta-Regular.ttf"

  # No zap stanza required
end