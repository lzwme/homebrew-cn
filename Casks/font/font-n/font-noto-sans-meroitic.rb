cask "font-noto-sans-meroitic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmeroiticNotoSansMeroitic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Meroitic"
  homepage "https:fonts.google.comspecimenNoto+Sans+Meroitic"

  font "NotoSansMeroitic-Regular.ttf"

  # No zap stanza required
end