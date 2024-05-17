cask "font-noto-sans-old-hungarian" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansoldhungarianNotoSansOldHungarian-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Old Hungarian"
  homepage "https:fonts.google.comspecimenNoto+Sans+Old+Hungarian"

  font "NotoSansOldHungarian-Regular.ttf"

  # No zap stanza required
end