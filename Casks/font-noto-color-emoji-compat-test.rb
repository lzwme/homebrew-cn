cask "font-noto-color-emoji-compat-test" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotocoloremojicompattestNotoColorEmojiCompatTest-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Color Emoji Compat Test"
  homepage "https:fonts.google.comspecimenNoto+Color+Emoji+Compat+Test"

  font "NotoColorEmojiCompatTest-Regular.ttf"

  # No zap stanza required
end