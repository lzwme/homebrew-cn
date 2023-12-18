cask "font-noto-sans-siddham" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssiddhamNotoSansSiddham-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Siddham"
  homepage "https:fonts.google.comspecimenNoto+Sans+Siddham"

  font "NotoSansSiddham-Regular.ttf"

  # No zap stanza required
end