cask "font-noto-emoji" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotoemojiNotoEmoji%5Bwght%5D.ttf",
      verified: "github.comgooglefonts"
  name "Noto Emoji"
  homepage "https:fonts.google.comspecimenNoto+Emoji"

  font "NotoEmoji[wght].ttf"

  # No zap stanza required
end