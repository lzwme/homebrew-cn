cask "font-black-ops-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflblackopsoneBlackOpsOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Black Ops One"
  homepage "https:fonts.google.comspecimenBlack+Ops+One"

  font "BlackOpsOne-Regular.ttf"

  # No zap stanza required
end