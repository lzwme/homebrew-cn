cask "font-gowun-dodum" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflgowundodumGowunDodum-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Gowun Dodum"
  homepage "https:fonts.google.comspecimenGowun+Dodum"

  font "GowunDodum-Regular.ttf"

  # No zap stanza required
end