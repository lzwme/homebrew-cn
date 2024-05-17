cask "font-noto-sans-modi" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmodiNotoSansModi-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Modi"
  homepage "https:fonts.google.comspecimenNoto+Sans+Modi"

  font "NotoSansModi-Regular.ttf"

  # No zap stanza required
end