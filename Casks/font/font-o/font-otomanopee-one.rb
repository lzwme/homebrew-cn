cask "font-otomanopee-one" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainoflotomanopeeoneOtomanopeeOne-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Otomanopee One"
  homepage "https:fonts.google.comspecimenOtomanopee+One"

  font "OtomanopeeOne-Regular.ttf"

  # No zap stanza required
end