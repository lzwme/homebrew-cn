cask "font-noto-sans-math" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmathNotoSansMath-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Math"
  homepage "https:fonts.google.comspecimenNoto+Sans+Math"

  font "NotoSansMath-Regular.ttf"

  # No zap stanza required
end