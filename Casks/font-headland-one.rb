cask "font-headland-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflheadlandoneHeadlandOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Headland One"
  homepage "https:fonts.google.comspecimenHeadland+One"

  font "HeadlandOne-Regular.ttf"

  # No zap stanza required
end