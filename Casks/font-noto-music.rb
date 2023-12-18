cask "font-noto-music" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflnotomusicNotoMusic-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Noto Music"
  homepage "https:fonts.google.comspecimenNoto+Music"

  font "NotoMusic-Regular.ttf"

  # No zap stanza required
end