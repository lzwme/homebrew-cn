cask "font-noto-sans-old-sogdian" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosansoldsogdianNotoSansOldSogdian-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Old Sogdian"
  homepage "https:fonts.google.comspecimenNoto+Sans+Old+Sogdian"

  font "NotoSansOldSogdian-Regular.ttf"

  # No zap stanza required
end