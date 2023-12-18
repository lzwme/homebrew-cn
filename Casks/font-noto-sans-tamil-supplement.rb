cask "font-noto-sans-tamil-supplement" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanstamilsupplementNotoSansTamilSupplement-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Tamil Supplement"
  homepage "https:fonts.google.comspecimenNoto+Sans+Tamil+Supplement"

  font "NotoSansTamilSupplement-Regular.ttf"

  # No zap stanza required
end