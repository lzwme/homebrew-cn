cask "font-noto-sans-mro" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmroNotoSansMro-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Mro"
  homepage "https:fonts.google.comspecimenNoto+Sans+Mro"

  font "NotoSansMro-Regular.ttf"

  # No zap stanza required
end