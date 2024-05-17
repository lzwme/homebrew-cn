cask "font-noto-sans-old-permic" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansoldpermicNotoSansOldPermic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Old Permic"
  homepage "https:fonts.google.comspecimenNoto+Sans+Old+Permic"

  font "NotoSansOldPermic-Regular.ttf"

  # No zap stanza required
end