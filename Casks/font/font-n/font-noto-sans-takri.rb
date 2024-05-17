cask "font-noto-sans-takri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanstakriNotoSansTakri-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Takri"
  homepage "https:fonts.google.comspecimenNoto+Sans+Takri"

  font "NotoSansTakri-Regular.ttf"

  # No zap stanza required
end