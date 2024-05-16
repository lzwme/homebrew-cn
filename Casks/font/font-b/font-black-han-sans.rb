cask "font-black-han-sans" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflblackhansansBlackHanSans-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Black Han Sans"
  homepage "https:fonts.google.comspecimenBlack+Han+Sans"

  font "BlackHanSans-Regular.ttf"

  # No zap stanza required
end