cask "font-young-serif" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflyoungserifYoungSerif-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Young Serif"
  homepage "https:fonts.google.comspecimenYoung+Serif"

  font "YoungSerif-Regular.ttf"

  # No zap stanza required
end