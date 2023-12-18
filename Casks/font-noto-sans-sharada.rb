cask "font-noto-sans-sharada" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotosanssharadaNotoSansSharada-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Sans Sharada"
  homepage "https:fonts.google.comspecimenNoto+Sans+Sharada"

  font "NotoSansSharada-Regular.ttf"

  # No zap stanza required
end