cask "font-noto-sans-manichaean" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansmanichaeanNotoSansManichaean-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Manichaean"
  homepage "https:fonts.google.comspecimenNoto+Sans+Manichaean"

  font "NotoSansManichaean-Regular.ttf"

  # No zap stanza required
end